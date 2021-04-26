#!/usr/bin/python3.8
# Collect statistics for export to prometheus.

import click
import datetime
import glob
import json
import os
import re
import subprocess
from concurrent import futures

REPOS = os.getenv('REPOS', '{{ bbserver_repo_home }}')

os.putenv('BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK', 'yes')
os.putenv('BORG_RELOCATED_REPO_ACCESS_IS_OK', 'yes')


def find_repos():
    assert os.path.isdir(REPOS)
    lst = []
    for readme in glob.glob('%s/**/README' % REPOS, recursive=True):
        repo = os.path.dirname(readme)
        # Borgmon will only look at top-level repos ending with '.repo'. To
        # monitor old repos we sometimes symlink them to a top-level '.repo'
        # name. Skip those symlinks when finding repos.
        if os.path.islink(repo):
            continue
        if open(readme).readline().strip() == 'This is a Borg Backup repository.':
            lst.append(repo)
    return lst


def repo_info(repo):
    s = subprocess.check_output(['borg', 'info', '--json', repo])
    return json.loads(s)


def for_all(func):
    result = []
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for path in find_repos():
            future = executor.submit(func, path)
            todos[future] = path
        for future in futures.as_completed(todos):
            path = todos[future]
            try:
                res = future.result()
            except Exception as e:
                print(path, "failed with", e)
            result.append((path, res))
    return result


def list_keys():
    for n, line in enumerate(open(os.path.expanduser("~/.ssh/authorized_keys"))):
        line.strip()
        if m := re.match(r'.*?restrict-to-path (.*?)".* (.*)$', line):
            yield (n+1, m.group(1), m.group(2))


# CLI

@click.group()
def cli():
    pass


@cli.command('list', help='List all repos')
def cli_list():
    l = []
    for path, info in for_all(repo_info):
        d = datetime.datetime.strptime(info['repository']['last_modified'],
                                       '%Y-%m-%dT%H:%M:%S.%f')
        l.append((d.strftime('%Y-%m-%d'), path))
    for date, path in sorted(l):
        print(date, path)


@cli.command('stale', help='Find stale keys and repos.')
def cli_stale():
    stale = 0
    keys  = []
    for n, path, user in list_keys():
        if not os.path.exists(path) or not os.listdir(path):
            stale += 1
            print('The ssh key on line %d points to a directory - '
                  '%s - that does not exist' % (n, path))
        else:
            keys.append(path)
    if not stale:
        print('No stale ssh keys')
    for repo in find_repos():
        if not [k for k in keys if repo.startswith(k)]:
            print('%s is not reachable by any ssh key' % repo)


@cli.command('monitor', help='Find repos not being monitored.')
def cli_monitor():
    links = [r for r in glob.glob(f'{REPOS}/*.repo') if os.path.islink(r)]
    repos = find_repos()
    longest = max(map(len, repos)) - len(REPOS)
    for repo in repos:
        shortPath = repo[len(REPOS)+1:]
        hdr = f'{shortPath:<{longest}} -'
        if (os.path.dirname(repo) == REPOS
            and repo.endswith('.repo')
            and not os.path.islink(repo)):
            print(hdr, 'is a new-style repo')
        if os.path.dirname(repo) != REPOS:
            ls = [l for l in links if repo.endswith(os.readlink(l))]
            if ls:
                assert len(ls) == 1
                l = ls[0][len(REPOS)+1:]
                print(hdr, 'symlinked by', l)
            else:
                print(hdr, 'seems to be unmonitored')

if __name__ == '__main__':
    cli()
