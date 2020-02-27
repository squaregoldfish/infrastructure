## Restoring from backup

Backups are available on fsicos, fsicos2 and cdb.

1. Show available backups
$ borg list /disk/data/bbserver/repos/fsicos2.lunarc.lu.se/restheart/default
backup1
backup2
backup3

2. Extract a backup - maybe the latest?
$ borg extract /disk/data/bbserver/repos/fsicos2.lunarc.lu.se/restheart/default::backup3

This will extract a single file, 'server.archive'.

3. Restore into a running restheart
$ docker exec -i restheart_mongodb_1 mongorestore --archive --drop < server.archive

4. Backups and restores are easy and stress-free
