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

function waitForDBShutdown {
	IS_DB_RUNNING=$(docker exec rdflogdb-v${PG_VERSION} bash -c 'psql -U postgres -d postgres -t -c ''\\dt''' || echo "nope")
	while [ "$IS_DB_RUNNING" != "nope" ]; do
		sleep 2
		IS_DB_RUNNING=$(docker exec rdflogdb-v${PG_VERSION} bash -c 'psql -U postgres -d postgres -t -c ''\\dt''' || echo "nope")
	done

	sleep 2
}

echo "Starting a fresh container and volume"
sed -i '/#      - \/disk\/data\/volumes\/rdflogdb-tmp-${PG_VERSION}:\/pg-tmp/c\      - \/disk\/data\/volumes\/rdflogdb-tmp-${PG_VERSION}:\/pg-tmp' docker-compose.yml
docker-compose down && rm -rf /disk/data/volumes/rdflogdb* && docker-compose up -d --build
waitForDBStartup

echo "Copying base from master to slave in temp folder 'master'"
# This requires that master lets in user 'rep' without a password
docker exec rdflogdb-v${PG_VERSION} bash -c 'pg_basebackup -h localhost -p 5433 -D /pg-tmp/master -U rep -v -P'

echo "Shutting down container"
docker-compose down
waitForDBShutdown

echo "Move slave base out of the way"
mv /disk/data/volumes/rdflogdb-${PG_VERSION}/* /disk/data/volumes/rdflogdb-tmp-${PG_VERSION}/slave.bak/

echo "Copy master base to pg data"
cp -r /disk/data/volumes/rdflogdb-tmp-${PG_VERSION}/master/* /disk/data/volumes/rdflogdb-${PG_VERSION}/

echo "Copy postgres.conf and recovery.conf to pg data"
cp /disk/data/volumes/rdflogdb-tmp-${PG_VERSION}/recovery.conf /disk/data/volumes/rdflogdb-${PG_VERSION}/
\cp -f /disk/data/volumes/rdflogdb-tmp-${PG_VERSION}/postgresql.conf /disk/data/volumes/rdflogdb-${PG_VERSION}/

echo "Set postgres as owner for pg data content"
#polkitd is postgres in the container
chown -R polkitd.polkitd /disk/data/volumes/rdflogdb-${PG_VERSION}/*

echo "Removing pg-tmp volume"
sed -i '/      - \/disk\/data\/volumes\/rdflogdb-tmp-${PG_VERSION}:\/pg-tmp/c\#      - \/disk\/data\/volumes\/rdflogdb-tmp-${PG_VERSION}:\/pg-tmp' docker-compose.yml
rm -rf /disk/data/volumes/rdflogdb-tmp-${PG_VERSION}

echo "Start container"
docker-compose up -d