#!/usr/bin/env bash

mv /tmp/pg_hba.conf /var/lib/postgresql/data/
chown postgres.postgres /var/lib/postgresql/data/pg_hba.conf
chmod 600 /var/lib/postgresql/data/pg_hba.conf

mv /tmp/postgresql.conf /var/lib/postgresql/data/
chown postgres.postgres /var/lib/postgresql/data/postgresql.conf
chmod 600 /var/lib/postgresql/data/postgresql.conf

mkdir /var/lib/postgresql/data/archive
chown postgres.postgres /var/lib/postgresql/data/archive