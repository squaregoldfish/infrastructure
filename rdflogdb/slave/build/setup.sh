#!/usr/bin/env bash

mkdir -p /pg-tmp/master
mkdir /pg-tmp/slave.bak

mv /tmp/pg_hba.conf /pg-tmp/pg_hba.conf
mv /tmp/postgresql.conf /pg-tmp/postgresql.conf
mv /tmp/recovery.conf /pg-tmp/recovery.conf

mkdir /var/lib/postgresql/data/archive
chown postgres.postgres /var/lib/postgresql/data/archive
