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
from concurrent import futures


MONITOR = os.path.join(os.environ['HOME'], 'monitor')

Repo = collections.namedtuple('Repo', ['name', 'path', 'narchives',
                                       'age_secs', 'size_mb'])


def get_repos():
    for d in os.listdir(MONITOR):
        yield (d, os.path.realpath(os.path.join(MONITOR, d)))


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
                print("""borg_age_secs{{name="{name}"}} {age_secs:f}
                borg_n_archives{{name="{name}"}} {narchives:f}
                borg_size_mb{{name="{name}"}} {size_mb:f}
                """.format(name=repo.name, age_secs=repo.age_secs,
                           size_mb=repo.size_mb, narchives=repo.narchives))


if __name__ == '__main__':
    main()
