#!/opt/jusers/venv/bin/python3
import grp
import os
import pwd
import random
import spwd
import subprocess
import sys
import requests
import pandas as pd

import click
from ruamel.yaml import YAML


PROJECT = '/project'
PRTEMPL = '/root/readme_template.html'
PR_URL  = 'https://fileshare.icos-cp.eu/s/JWncSTWTFKyFZ3t/download'
DRY_RUN = False
VERBOSE = False
USERSDB = '/root/jusers.yml'
PWDLENG = 10


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

def maybe_kick_user(user):
    if diff_user_groups(user):
        yield ('yesno "%s\'s user credentials have changed, shut down their '
               ' server? " && docker rm -f jupyter-%s || :' % (user, user))


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


def diff_user_groups(user):
    r = subprocess.run('docker exec jupyter-%s id %s' % (user, user),
                       shell=True, check=False, capture_output=True, text=1)
    if r.returncode == 1 and "No such container" in r.stderr:
        return None
    if r.returncode == 1:
        raise Exception(r.stderr)
    dock = r.stdout.strip()
    host = subprocess.check_output(['id', user], text=1).strip()
    return dock != host


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
    s = subprocess.check_output(['docker', 'ps'], text=1)
    for line in s.splitlines():
        words = line.split()
        if words[-1].startswith('jupyter-'):
            _, user = words[-1].split('-', 1)
            yield from maybe_kick_user(user)


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


@cli.command()
@click.option('-p', '--project', default='', help='project folder name')
@click.option('-f', '--force', is_flag=True, help='force replace existing README.html')
def project_readme(project, force):
    """Create a README.html page for projects.

    Based on a template (/root/readme_template.html) a customized project
    README.html is created and copied to /project/...../store/README.html

    The contact information, description, PI etc. is read from the cp fileshare
    'elaboroated products/jupyter/projectgroups/jupyterhub_projectgroup_info.xlsx'
    https://fileshare.icos-cp.eu/s/JWncSTWTFKyFZ3t/download'

    Running this command without an argument will create a new README.html
    for all projects listed in the excel file. Existing README.html files
    are NOT replaced.

    You can create a new README.html for a specific project by providing
    the project name.

    By default --force is set to false, hence existing files are NOT overwritten

    Examples:

    \b
      $ jusers project_readme inverse
             creates a new README.html file IF the file does NOT exist
      $ jusers project_readme inverse --force
             creates a new README.html overwrite existing file
      $ jusers project_readme -f
             replace or create new README.html files for ALL projects

    """

    # read excel file from fileshare or use provided project name
    try:
       re = requests.get(PR_URL)
       df = pd.read_excel(re.content)
    except:
        print('reading fileshare document failed')

    if not project:
        project = list(df.folder.values)
    else:
        project = project.split()

    template = open(PRTEMPL).read()

    for p in project:
        # check if the actual project folder exists..
        pfolder = join(PROJECT, p)
        if not os.path.exists(pfolder):
            print(pfolder, ' not found')
            continue

        # path to project readme
        fn = join(pfolder, '/store/README.html')

        if os.path.exists(fn) and not force:
            print(p, 'skip')
            continue

        with open(fn, "w") as f:
            info = df.loc[df.folder==p].values[0]
            f.write(template%(info[0], info[1], info[2], info[2], info[3]))
            print(p, 'create or replace readme.html')


# MAIN
if __name__ == '__main__':
    cli()
