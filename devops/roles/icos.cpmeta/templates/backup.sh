#!/bin/bash

set -Eeo pipefail

cd "{{ cpmeta_home }}"

if [[ -z "${1:-}" ]]; then
    ARCHIVE="test-{now}"
else
    ARCHIVE="$1-{now}"
fi

export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

LOGFILE=backup.log
HEADER="=== starting backup"

echo "$HEADER $(date)" >> $LOGFILE

# borg(1) outputs some information to stderr (as well as stdout). This doesn't
# sit well with cron, which will think that an error occured and send a mail to
# root. So we capture all output to a logfile, detect when borg fails, and
# then manually output the logs for the last run.
if ! ./bin/bbclient-all create --verbose --stats               \
     "::$ARCHIVE" "{{ cpmeta_filestorage_target }}" rdfStorage \
     >> "$LOGFILE" 2>&1; then
    # output everything after the last header
    sed -ne ":a;\$p;N;/$HEADER/d;ba"  < "$LOGFILE"
    # signal to cron that we failed
    exit 1
fi

echo "=== pruning backups" >> $LOGFILE
./bin/bbclient-all prune --stats                                     \
                   --keep-within 7d --keep-daily=30 --keep-weekly=50 \
                   >> $LOGFILE 2>&1
