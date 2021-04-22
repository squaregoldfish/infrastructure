#!/usr/bin/python3
# Collect statistics for export to prometheus.
#
# Each borg repo that is to be monitored is linked to the 'monitor'
# directory. This script will then - in parallell no less ! - execute several
# command line utils to extract information about each repo and print them to
# standard output in a format edible by node_exporters textfile collector.

import collections
import datetime
import json
import os
import subprocess
import sys
from concurrent import futures


TEXTFILES = os.getenv('TEXTFILES', '{{ bbserver_textfiles }}')
REPOS = os.getenv('REPOS', '{{ bbserver_repo_home }}')

Repo = collections.namedtuple('Repo', ['name', 'path', 'narchives',
                                       'age_secs', 'size_mb'])


# UTILS
def wrap_stdout(func):
    if sys.stdin.isatty():
        func()
    else:
        out_path = os.path.join(TEXTFILES, 'bbserver.prom')
        tmp_path = '%s.%d' % (out_path, os.getpid())
        tmp_file = open(tmp_path, 'w')
        old_stdout = sys.stdout
        sys.stdout = tmp_file
        try:
            func()
        except:
            os.unlink(tmp_path)
        else:
            tmp_file.close()
            os.rename(tmp_path, out_path)
        finally:
            sys.stdout = old_stdout


# BORG STUFF

def get_repos():
    for d in os.listdir(REPOS):
        if not d.endswith('.repo'):
            continue
        yield (d[:-len('.repo')], os.path.realpath(os.path.join(REPOS, d)))


def list_archives(repo):
    s = subprocess.check_output(
        ['borg', 'list', '--json', '--sort-by', 'timestamp', repo])
    return json.loads(s)


def repo_size(repo):
    return int(subprocess.check_output(['du', '-mxs', repo]).split()[0])


def stat_repo(name, path):
    ars = list_archives(path)
    size_mb = repo_size(path)
    last_mod = datetime.datetime.strptime(ars['repository']['last_modified'],
                                          '%Y-%m-%dT%H:%M:%S.%f')
    age_secs = (datetime.datetime.now() - last_mod).seconds
    return Repo(name, path, len(ars['archives']), age_secs, size_mb)


# MAIN

def main():
    with futures.ProcessPoolExecutor() as executor:
        todos = {}
        for (name, path) in get_repos():
            future = executor.submit(stat_repo, name, path)
            todos[future] = name
        # HELP and TYPE must only appear once for each value.
        print("""\
# HELP borg_age_secs Time of last backup
# TYPE borg_age_secs gauge

# HELP borg_narchives Number of archives in repo
# TYPE borg_n_archives counter

# HELP borg_size_mb Size of repo in megabytes
# TYPE borg_size_mb Counter""")
        for future in futures.as_completed(todos):
            name = todos[future]
            try:
                repo = future.result()
            except Exception as e:
                print(name, "failed with", e)
            else:
                # This file is deployed as a ansible template, that means that
                # too many braces in the below code (i.e by turning it into a
                # python f-string) will clash with the jinja2 syntax of ansible
                # templates.
                ls = ['borg_age_secs{name="%s"} %f' % (name, repo.age_secs),
                      'borg_n_archives{name="%s"} %f' % (name, repo.narchives),
                      'borg_size_mb{name="%s"} %f' % (name, repo.size_mb),
                      ]
                print('\n'.join(ls))

if __name__ == '__main__':
    wrap_stdout(main)
