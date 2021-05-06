#!/opt/jusers/venv/bin/python3
import grp
import os
import pwd
import random
import spwd
import subprocess
import sys
import click

from concurrent.futures import ProcessPoolExecutor
from ruamel.yaml import YAML


PROJECT = '/project'
DRY_RUN = False
VERBOSE = False
USERSDB = '/root/jusers.yml'
PWDLENG = 10


# PLUGINS
# https://click.palletsprojects.com/en/7.x/commands/?highlight=plug#custom-multi-commands
class Plugins(click.MultiCommand):

    folder = os.path.join(os.path.dirname(os.path.realpath(__file__)),
                          'plugins')

    def list_commands(self, ctx):
        rv = []
        for filename in os.listdir(self.folder):
            if filename.endswith('.py'):
                rv.append(filename[:-3])
        rv.sort()
        return rv

    def get_command(self, ctx, name):
        fn = os.path.join(self.folder, name + '.py')
        ns = {'__file__': fn}
        with open(fn) as f:
            code = compile(f.read(), fn, 'exec')
            eval(code, ns, ns)
        return ns['cli']

# UTIL
def join(*args):
    return os.path.join(*args)


def exists(*args):
    return os.path.exists(os.path.join(*args))


def readlink(*args):
    try:
        return os.readlink(os.path.join(*args))
    except Exception:
        return None


# DOCKER
def user_database_differs():
    c = 'sha1sum /etc/passwd /etc/shadow /etc/group'
    r = subprocess.run('diff -Zq <(docker exec -t hub %s) <(%s) > /dev/null' % (
        c, c), check=False, shell=True, executable='/bin/bash')
    return r.returncode != 0

def maybe_restart_hub(force=False):
    if user_database_differs() or force:
        yield "cd /docker/jupyter && docker-compose restart hub"

def docker_id(user):
    r = subprocess.run('docker exec jupyter-%s id %s' % (user, user),
                       shell=True, check=False, capture_output=True, text=1)
    if r.returncode == 1 and "No such container" in r.stderr:
        return None
    if r.returncode == 1:
        raise Exception(r.stderr)
    return r.stdout.strip()


# USERS
def list_users():
    users = []
    for pw in pwd.getpwall():
        if is_normal_user(pw.pw_name, pw.pw_uid):
            users.append(pw.pw_name)
    return sorted(users)


def list_passwordless_users(yaml):
    for u in yaml['users']:
        l = u['login']
        sp = spwd.getspnam(l)
        if sp.sp_pwdp in ('!', '*'):
            yield l


def is_normal_user(user, uid=None):
    if uid is None:
        try:
            uid = pwd.getpwnam(user).pw_uid
        except KeyError:  # returned for non-existing users
            return False
    return uid >= 1000 and user not in ['nobody', 'project']


# GROUPS
def is_group(name):
    try:
        grp.getgrnam(name)
        return True
    except KeyError:
        return False


def list_project_groups():
    return sorted(g.gr_name for g in grp.getgrall()
                  if exists(PROJECT, g.gr_name))


def list_user_groups(user):
    try:
        pw_gid = pwd.getpwnam(user).pw_gid
    except KeyError: # user doesn't exist
        return []
    else:
        return [g.gr_name for g in grp.getgrall()
                if (g.gr_gid == pw_gid or user in g.gr_mem)
                and exists(PROJECT, g.gr_name)
                and g.gr_name != 'common']


def reset_passwords(reset):
    ps = []
    for u in reset:
        p = random.randint(1*(10**PWDLENG), 1*(10**(PWDLENG+1))-1)
        ps.append((u, p))
    ls = '\n'.join('%s:%s' % (u, p) for u, p in ps)
    subprocess.run(['/sbin/chpasswd'], input=ls, check=1, text=1)
    print("Reset passwords:\n%s" % '\n'.join('  %-15s%s' % (u, p) for u, p in ps))


# GENERATE COMMANDS
def add_group(group):
    if is_group(group):
        yield "echo %s already exists" % group
        return
    if is_normal_user(group):
        yield 'abort %s is the name of a regular user' % group
        return
    r = join(PROJECT, group)
    if exists(r):
        yield "abort %s exists although the group does not" % group
        return
    yield 'groupadd %s' % group
    yield 'mkdir -p %s/store' % r
    yield 'chmod 2770 %s' % r
    yield 'chown project:%s %s' % (group, r)
    yield 'echo added group %s' % group


def maybe_kick_all_users():
    # First list all jupyter containers that are user notebook servers and
    # build a dict that maps username to the output of "id user" on the host.
    users = {}
    s = subprocess.check_output(['docker', 'ps'], text=1)
    for line in s.splitlines():
        words = line.split()
        if words[-1].startswith('jupyter-'):
            _, user = words[-1].split('-', 1)
            hid = subprocess.check_output(['id', user], text=1).strip()
            users[user] = hid
    # Next go through the usernames and spawn a background process that runs
    # 'docker id jupyter-user id user'. This means that on a busy server we
    # might start 50-100 'docker exec' processes.
    # We then compare the output of 'id user' on the host vs in docker.
    kick = []
    with ProcessPoolExecutor() as exe:
        jobs = [(user, exe.submit(docker_id, user)) for user in users]
        for user, job in jobs:
            try:
                dock = job.result()
                host = users[user]
                if dock != host :
                    kick.append(('yesno "%s\'s user credentials have changed, '
                                 'shut down their server? " && '
                                 'docker rm -f jupyter-%s || :' % (user, user)))
            except Exception as e:
                print(user, "failed with", e)
    return kick


def sync_new_groups(yaml):
    e_groups = list_project_groups()
    y_groups = yaml['groups']
    for ng in set(y_groups) - set(e_groups):
        yield from add_group(ng)


def sync_new_users(yaml):
    y_users = yaml['users']
    e_users = list_users()
    for u in y_users:
        l = u['login']
        if l in e_users:
            continue
        yield 'useradd --create-home --user-group %s' % l


def sync_user_groups(yaml):
    for u in yaml['users']:
        l = u['login']
        for g in set(u.get('groups', [])) - set(list_user_groups(l)):
            yield 'usermod -G %s -a %s' % (g, l)


def sync_homedirs(yaml):
    for u in yaml['users']:
        login = u['login']
        if not is_normal_user(login):
            continue

        home = pwd.getpwnam(login).pw_dir
        pcom = join(PROJECT, 'common')
        if readlink(home, 'common') != pcom:
            yield 'ln -sf %s %s' % (pcom, home)

        project = join(home, 'project')
        if not exists(project):
            yield 'mkdir -pm 0755 %s' % project

        for g in list_user_groups(login):
            p = join(PROJECT, g)
            if readlink(project, g) != p:
                yield 'ln -sf %s %s' % (p, project)


# RUN
def run(*gens):
    flags = "set -eu"
    if VERBOSE:
        flags += "x"
    init = ["#!/bin/bash", flags,
            'error () { echo "$@" > /dev/stderr; }',
            'abort () { echo "$@" > /dev/stderr; exit 1; }',
            'yesno () { read -p "$* [yn]: " a; [[ $a == y ]]; }']
    if DRY_RUN:
        cmds = [l for g in gens for l in g]
        if len(cmds) == 0:
            return print("Everything is synced.")
        else:
            return print('\n'.join(cmds))
    ncs = 0
    for g in gens:
        cmds = init[:]
        for line in g:
            cmds.append(line)
            ncs += 1
        prog = '\n'.join(cmds)
        r = subprocess.run(['/bin/bash', '-c', prog])
        if r.returncode != 0:
            print("abort.")
            sys.exit(1)
    if ncs == 0:
        print("Everything is synced.")


# CLI
@click.group()
def cli():
    pass


@cli.command()
@click.option('--force', '-f', is_flag=True, help="force restart")
def restart_hub(force):
    """Restart the hub.

    All users are managed on the host system. The jupyter hub then keeps a copy
    of the user database. This means that if the user database is updated,
    then the hub needs to be restarted for those changes to take effect.

    Running this command will restart the hub, but only if the hub doesn't have
    the latest user database.

    \b
    $ jusers restart-hub
    Everything is synced.


    \b
    $ jusers restart-hub --force
    Restarting hub ...

    """
    run(maybe_restart_hub(force))


@cli.command()
@click.option('--may-the-force-be-with-me', is_flag=True, help="Execute commands.")
def sync(may_the_force_be_with_me):
    """Read jusers.yml and output commands needed to sync it.

    In the simplest case, everything is already up-to-date:

    \b
      $ jusers sync
      Everything is synced.

    Let's say we add a new user to jusers.yml:

    \b
       - login: beeblebrox
         groups:
           - cake
           - sausage

    Re-running the sync command will now output the commands needed to move the
    host closer to what is described by users.yml:

    \b
      $ jusers sync
      useradd --create-home --user-group beeblebrox
      usermod -G cake -a beeblebrox
      usermod -G sausage -a beeblebrox

    These commands needs to be run manually - either directly or by piping them
    into bash - until sync reports that 'Everything is synced.'

    The sync command also has the capability to run these commands on its own,
    in which case it only needs to be run once. This is accomplished by passing
    the correct option to sync.

    \b
      $ jusers sync --may-the-force-be-with-me
      + useradd --create-home --user-group beeblebrox
      + usermod -G cake -a beeblebrox
      + usermod -G sausage -a beeblebrox
      + ln -sf /project/common /home/beeblebrox
      + mkdir -pm 0755 /home/beeblebrox/project
      + ln -sf /project/cake /home/beeblebrox/project
      + ln -sf /project/sausage /home/beeblebrox/project
      + cd /docker/jupyter
      + docker-compose restart hub
      Restarting hub ...

    """
    global DRY_RUN, VERBOSE
    if not may_the_force_be_with_me:
        DRY_RUN = True
    else:
        VERBOSE = True
    yaml = YAML(typ='safe').load(open(USERSDB, 'rb'))
    run(sync_new_groups(yaml),
        sync_new_users(yaml),
        sync_user_groups(yaml),
        sync_homedirs(yaml),
        maybe_restart_hub(),
        maybe_kick_all_users())


@cli.command()
@click.argument('users', nargs=-1, required=False)
def set_passwords(users):
    """Manage user passwords.

    When a user is created, its password is unset. To be able to login, their
    password needs to be set.

    Running this command without an argument will list all users without
    passwords.  The command can then be rerun with a list of users whose
    password is to be reset. The passwords are reset to randomly generated
    passwords.

    If any passwords were reset, the jupyter hub will be restarted in order for
    the changes to take affect.

    \b
      $ jusers set-passwords
      The following users does not have a password set:
        alice
        bob
        beeblebrox
    \b
      $ jusers set-passwords alice bob
      Reset passwords:
        alice          48605338769
        bob            96465289213
      Restarting hub ...

    """
    yaml = YAML(typ='safe').load(open(USERSDB, 'rb'))
    if not users:
        pwless = list(list_passwordless_users(yaml))
        if pwless:
            print("The following users does not have a password set:\n"
                  "  %s" % '\n  '.join(pwless))
        else:
            print("All users have a password set.")
    else:
        reset_passwords(users)
        run(maybe_restart_hub())


# MAIN
if __name__ == '__main__':
    cli = click.CommandCollection(sources=[cli, Plugins()])
    cli()
