#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER rep REPLICATION
	LOGIN CONNECTION LIMIT 1
	PASSWORD 'some_replication_password';
EOSQL