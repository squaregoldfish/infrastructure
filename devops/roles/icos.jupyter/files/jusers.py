#!/opt/jusers/venv/bin/python3
import click
import grp
import os
import pwd
import subprocess
import sys
from ruamel.yaml import YAML


PROJECT = '/project'
DRY_RUN = True
VERBOSE = True
USERSDB = '/root/jusers.yml'


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
    pw_gid = pwd.getpwnam(user).pw_gid
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
        yield('useradd --create-home --user-group %s' % l)
        for g in u.get('groups', []):
            yield 'usermod -G %s -a %s' % (g, l)


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
            return print("Already synced.")
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
        print("Already synced.")


# CLI
@click.group()
def cli():
    pass


@cli.command(help="Restart hub (if needed)")
@click.option('--force', '-f', is_flag=True, help="force restart")
def restart_hub(force):
    run(maybe_restart_hub(force))


@cli.command(help='Sync jusers.yaml')
@click.option('--may-the-force-be-with-me', is_flag=True, help="Execute commands.")
def sync(may_the_force_be_with_me):
    global DRY_RUN, VERBOSE
    if may_the_force_be_with_me:
        DRY_RUN = False
        VERBOSE = True
    yaml = YAML(typ='safe').load(open(USERSDB, 'rb'))
    run(sync_new_groups(yaml),
        sync_new_users(yaml),
        sync_user_groups(yaml),
        sync_homedirs(yaml),
        maybe_restart_hub(),
        maybe_kick_all_users())


# MAIN
if __name__ == '__main__':
    cli()
