#!/opt/jbuild/venv/bin/python3

import click
import docker
import git
import os
import subprocess
import sys

from subprocess import Popen, PIPE, STDOUT, run
from collections import OrderedDict
from pathlib import Path

# TODO: detect simultaneous builds
# TODO: mapping of username to branch names?
# TODO: autoclean images on exploredata


# GLOBALS

WORKDIR = Path.home().joinpath('jbuild')
JUPYDIR = WORKDIR.joinpath('jupyter')
JUPYURL = 'https://github.com/ICOS-Carbon-Portal/jupyter/'
REGSTRY = "registry.icos-cp.eu"

USER = os.environ['USER']
REPO = None



# HELPERS

def yesno(msg):
    if not sys.stdin.isatty():
        die('No terminal, cannot answer question "%s"' % msg)
    while True:
        ans = input('%s [yn] ' % msg).lower()
        if ans == 'y':
            return True
        if ans == 'n':
            return False


def init():
    global REPO

    if not WORKDIR.exists():
        WORKDIR.mkdir()

    os.chdir(WORKDIR)

    if not JUPYDIR.exists():
        print('Cloning jupyter repo into %s' % JUPYDIR)
        run(['git', 'clone', JUPYURL], check=1)
        assert JUPYDIR.exists()
        print("Cloned jupyter into %s" % JUPYDIR)

    REPO = git.Repo(JUPYDIR)


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def ask_for_branch():
    refs = OrderedDict((r.name[len('origin/'):], r) for r in
                       sorted(REPO.refs, reverse=True,
                              key=lambda ref: ref.commit.authored_datetime)
                       if (r.is_remote() and r.remote_name == 'origin'
                           and not r.name.endswith('HEAD')))
    last = list(refs.keys())[:5]
    while True:
        print('The newest %d branches are: \n  %s' % (
            len(last), '\n  '.join(last)))
        b = input('Please specify which branch to build (blank for %s): ' % (
            last[0]))
        if b == '':
            b = last[0]
        if not b in refs:
            print('Cannot find branch "%s"' % b)
        else:
            return refs[b]


# ACTIONS

def build(ref, what):
    # e.g /home/user/jbuild/jupyter/docker/icosbase
    dockerf = JUPYDIR.joinpath('docker', what, 'Dockerfile')
    bldargs = []

    if what == 'icosbase':
        context = JUPYDIR.joinpath('docker', 'icosbase')
    elif what == 'exploredata':
        context = JUPYDIR.joinpath('notebooks')
    else:
        assert 0, what

    # Tag the images as "exploredata-alice"
    tag = '%s-%s' % (what, USER)
    if what == 'exploredata':
        bldargs = ['--build-arg=BASE=icosbase-%s' % USER]

    logpath = WORKDIR.joinpath('%s.log' % what)
    print('Building %s - complete log in %s' % (tag, logpath))

    with open(logpath, 'w', buffering=1) as log:
        a = ['docker', 'build', *bldargs, '--tag', tag, context, '-f', dockerf]
        print(' '.join(map(str, a)), file=log)
        r = subprocess.Popen(a, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, text=1)
        for n, line in enumerate(r.stdout):
            log.write(line)
            if line.startswith('Step '):
                # Only print the 'Step x/y' part.
                print('\r' + line.split(':')[0] + '\r', end='')

        # We need to wait() until returncode is set.
        r.wait()
        if r.returncode != 0:
            die("docker build failed - see %s for details" % logpath)

    print('Successfully built %s' % tag)
    return tag



def push(what, local_tag):
    assert what in ('test', 'prod', 'jupyter'), what

    # SETUP
    client = docker.from_env()
    img = client.images.get(local_tag)
    if what in ('prod', 'test'):
        cmd = ['edctl', 'pull%s' % what]
        push_tag = f'registry.icos-cp.eu/exploredata.{what}.notebook'
    else:
        cmd = ['jyctl', 'pull']
        push_tag = 'registry.icos-cp.eu/icosbase'

    # LOCAL PUSH
    img.tag(push_tag)
    hdr = f"Pushing {push_tag} - %s"
    for update in client.images.push(push_tag, stream=True, decode=True):
        # This will detect e.g missing docker login credentials.
        if error := update.get('error'):
            die(f"Error while pushing '{push_tag}' to registry - {error}")
        print(hdr % update.get('id') + "\r", end='')
    print(hdr % "done")

    # REMOTE PULL
    hdr = "Remote is pulling %s - %%-15s" % push_tag
    print(hdr % 'starting' + '\r', end='')
    p = Popen(cmd, stdout=PIPE, stderr=STDOUT, text=1)
    for line in p.stdout:
        line = line.strip()
        # This is the last line and contains the short_id of the image.
        if line.startswith('short_id'):
            short_id = line.strip().split()[-1]
            # The image as received on exploredata is the same as we pushed.
            assert short_id == img.short_id, (short_id, img.short_id)
        # The other lines are status updates.
        elif line == 'done':
            print(hdr % 'done')
        else:
            print(hdr % line + '\r', end='')
    p.wait()
    if p.returncode != 0:
        die('%s failed' % ' '.join(cmd))


def sync_notebooks():
    run(['rsync', '-vtr',
         "%s/" % JUPYDIR.joinpath("notebooks"),
         'projectcommon:'],
        check=1)


# CLI
@click.group()
def cli():
    pass


@cli.command('info', help='Shows images in use.')
def cli_info():
    r = run(['edctl', 'images'], text=1, capture_output=1)
    test = None
    prod = None
    for line in r.stdout.splitlines():
        # Standard outout from 'docker images', minus the header line.
        repo, tag, iid, *_ = line.split()
        if repo.endswith('test.notebook'):
            test = iid
        if repo.endswith('prod.notebook'):
            prod = iid
    client = docker.from_env()
    for name, tag in (('test', test), ('prod', prod)):
        if tag is None:
            print(f'Exploredata has no {name}.notebook image (!?).')
        else:
            try:
                img = client.images.get(tag)
            except docker.errors.ImageNotFound:
                print(f'There is no local image corresponding to the '
                      f'{name}.notebook image in exploredata')
                continue
            # If one of the local tags starts with 'exploredata-' then it contains
            # the name of the user that built the image now used on
            # exploredata.
            user_tag = [t for t in img.tags if t.startswith('exploredata-')
                        and t.endswith(':latest')]
            if len(user_tag) == 1:
                print(f'Exploredata is using the '
                      f'{user_tag[0]} image as its {name}.notebook')
            else:
                print(f'Exploredata is using the {img} as its {name}.notebook.')


@cli.command('run', help='Build, push images, sync notebooks.')
@click.argument('branch', required=False)
@click.option('--fetch/--no-fetch', default=True, help="Fetch from github")
def cli_run(branch, fetch):
    os.chdir(JUPYDIR)

    if fetch:
        print('Fetching from origin.')
        for info in REPO.remotes.origin.fetch(verbose=False):
            print('  %s' % info)

        if branch is None:
            ref = ask_for_branch()
        else:
            ref = None
            for r in REPO.refs:
                if r.name == branch:
                    ref = r
                    break
            else:
                die(f"Cannot find branch {branch}")

        print(f'Checking out {ref}')
        try:
            ref.checkout()
        except git.GitCommandError as err:
            die(str(err))
    else:
        # Use the local jbuild repo, with any changes.
        ref = REPO.head

    icosbase_tag = build(ref, 'icosbase')
    exploredata_tag = build(ref, 'exploredata')

    push('test', exploredata_tag)

    if yesno('Exploretest has been updated, please check it manually. '
             'Do you now want to deploy exploreprod as well?'):
        push('prod', exploredata_tag)

    if yesno('Do you want to push the new docker image to jupyter?'):
        push('jupyter', icosbase_tag)

    if yesno('Do you want to sync notebooks to jupyter.icos-cp.eu?'):
        sync_notebooks()


@cli.command('sync', help="Sync notebooks to jupyter.icos-cp.eu:/project/common")
def cli_sync():
    sync_notebooks()



# MAIN

if __name__ == '__main__':
    init()
    cli()
