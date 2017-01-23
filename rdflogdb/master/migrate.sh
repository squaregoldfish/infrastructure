#!/usr/bin/env bash

# Load environment variables
source ./.env

function waitForDBStartup {
	IS_DB_RUNNING=$(docker exec rdflogdb-v${PG_VERSION} bash -c 'psql -U postgres -d postgres -t -c ''\\dt''' || echo "nope")
	while [ "$IS_DB_RUNNING" == "nope" ]; do
		sleep 2
		IS_DB_RUNNING=$(docker exec rdflogdb-v${PG_VERSION} bash -c 'psql -U postgres -d postgres -t -c ''\\dt''' || echo "nope")
	done

	sleep 10
}

# !!! Note that this command erases rdf docker volumes !!!
#echo "Starting a fresh container and volume"
#docker-compose down && rm -rf /disk/data/volumes/rdf* && docker-compose up -d --build
#waitForDBStartup

echo "Dumping source DB"
docker exec rdflogdb_rdflogdb_1 bash -c 'pg_dump -U postgres --format=c --file /var/lib/postgresql/data/pgdata/dump.sqlc postgres'

echo "Moving dump file to destination DB volume"
mv /disk/data/postgres/rdflog/pgdata/dump.sqlc /disk/data/volumes/rdflogdb-${PG_VERSION}/dump.sqlc

echo "Restoring dump on destination DB"
docker exec rdflogdb-v${PG_VERSION} bash -c 'pg_restore -U postgres -j 4 --dbname=postgres /var/lib/postgresql/data/dump.sqlc'

echo "Deleting dump file on destination DB volume"
rm -f /disk/data/volumes/rdflogdb-${PG_VERSION}/dump.sqlc

SOURCE_SCHEMA=$(docker exec rdflogdb_rdflogdb_1 bash -c 'psql -U postgres -d postgres -t -c ''\\d''')
DESTINATION_SCHEMA=$(docker exec rdflogdb-v${PG_VERSION} bash -c 'psql -U postgres -d postgres -t -c ''\\d''')

if [ "$SOURCE_SCHEMA" != "$DESTINATION_SCHEMA" ]
then
	echo "Schema mismatch!!"
	exit 1
fi
