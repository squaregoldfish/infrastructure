#!/bin/bash
# Backup

set -e
set -u

PATH=$HOME/bin:$PATH

tmp=$(mktemp -d /tmp/quince-backup.XXXXXX)
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

# Redirect stderr to real stdout, then stdout to file, then run awk on stderr.
mysqldump --single-transaction --quick --user=quince --password=quince --hex-blob quince 2>&1 > mysql.dump \
    | awk '! /Using a password on the command line interface can be insecure./'

bbclient-all create '::{now}' mysql.dump /opt/quince_filestore

bbclient-all prune --keep-within 7d --keep-daily=30 --keep-weekly=150
