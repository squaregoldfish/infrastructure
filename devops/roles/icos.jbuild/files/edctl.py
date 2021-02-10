#!/opt/edctl/venv/bin/python3

import click
import docker
import os
import sys

from subprocess import run

REPO_URL = 'registry.icos-cp.eu/exploredata.%s.notebook'


def flush(*args, **kwargs):
    print(*args, **kwargs)
    sys.stdout.flush()


def pull(what):
    assert what in ('test', 'prod')
    dock = docker.from_env()
    for update in dock.api.pull(REPO_URL % what, stream=True, decode=True):
        flush(update.get('id'))
    flush('done')
    img = dock.images.get(REPO_URL % what)
    # sha256:c166280023
    flush('short_id %s' % img.short_id)


@click.group()
def cli():
    pass


@cli.command('')
def images():
    r = run(['docker', 'images', REPO_URL % '*'],
            text=1, check=1, capture_output=1)
    for n, line in enumerate(r.stdout.splitlines()):
        # Skip header.
        if n == 0:
            continue
        print(line)


@cli.command('pulltest')
def pull_test():
    pull('test')


@cli.command('pullprod')
def pull_prod():
    pull('prod')


if __name__ == '__main__':
    cmd = os.environ.get('SSH_ORIGINAL_COMMAND')
    if cmd:
        argv = cmd.split()
    else:
        argv = sys.argv
    cli(args=argv[1:])
