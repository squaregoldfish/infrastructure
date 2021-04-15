#!/usr/bin/python3

import contextlib
import os
import shlex
import sys
import tempfile
from datetime import datetime
from pathlib import Path
from subprocess import PIPE, Popen, STDOUT, run


BASE = Path(os.environ.get("BASE", "{{ prometheus_home }}"))
GRAFANA_DB = BASE.joinpath("volumes/grafana_data/grafana.db")
BBCLIENT = BASE.joinpath("bin/bbclient-all")
LOGFILE = BASE.joinpath("backup.log")

assert GRAFANA_DB.exists()


def logfile():
    if sys.stdin.isatty():
        return contextlib.nullcontext(sys.stdout)
    else:
        return open(LOGFILE, "a")


def logfmt(msg):
    return "%s - %s" % (datetime.now().isoformat(timespec="minutes"), msg)


def bbclient(what, arg):
    with logfile() as log:
        print(logfmt(what), file=log, flush=True)
        run([BBCLIENT] + shlex.split(arg), check=1, stdout=log, stderr=STDOUT)


def die(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)


def backup():
    with tempfile.TemporaryDirectory() as tmp:
        os.chdir(tmp)
        p = Popen(["sqlite3", GRAFANA_DB], stdin=PIPE, stdout=PIPE,
                  stderr=STDOUT, text=1)
        outs, _ = p.communicate(".backup grafana.db")
        if p.returncode != 0:
            die(f"sqlite3 failed with '{outs}'")
        assert(os.path.exists('grafana.db'))
        bbclient('create backup', 'create --verbose --stats "::{now}" .')
        bbclient('prune backup', 'prune --verbose --stats '
                 '--keep-within 7d --keep-daily=30 --keep-weekly=150')

    
if __name__ == '__main__':
    backup()
