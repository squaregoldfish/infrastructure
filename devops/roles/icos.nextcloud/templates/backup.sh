#!/bin/bash
# Backup nextcloud twice - first hot and then cold.
#
# Nextcloud used to be backed up using the bbclient-coldbackup script, that
# script will:
#   Bring down nextcloud (docker-compose down)
#   Backup all docker storage - i.e file storage and postgres - using borg(1)
#   Bring nextcloud up again
#
# The reason for bringing nextcloud down is that the nextcloud manual
# recommends putting nextcloud into "maintenance" mode before backup up. Since
# maintenance mode prohibits anyone from actually using nextcloud, we might as
# well bring it down.
#
# This process takes about 30 seconds when there has been no uploads to
# nextcloud. The problem arises - and that this script tries to fix - is when
# someone has uploaded huge amounts of data to nextcloud.
#
# The way this script tries to fix it is to do a "dirty" backup, meaning
# leaving nextcloud up and running while backing up the file storage. Once that
# is done, we repeat the backup, this time using bbclient-coldbackup. The idea
# is that most files will not have changed between the two backups and borg(1)
# will detect this and only backup the changes.

set -Eueo pipefail

cd "{{ nextcloud_home }}"

ARCHIVE="dirty-{now}"
LOGFILE=backup.log

echo "=== starting dirty backup" >> "$LOGFILE"
bin/bbclient-all create --stats --verbose "::$ARCHIVE" volumes/nextcloud >> "$LOGFILE" 2>&1

bin/bbclient-coldbackup cron
