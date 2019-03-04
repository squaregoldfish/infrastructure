#!/bin/bash

set -e

cd "{{ rdflog_home }}"

# If stdout is a tty then we need the '-t' flag, otherwise we're redirecting to
# a file and we must not have "-t". 
if [ -t 0 ] && [ -t 1 ]; then O="-it"; else O="-i"; fi

# And just when you thought it was cloudy enough!
# https://github.com/docker/compose/issues/3352
CID=$(docker-compose -f docker-compose.yml ps -q db)

docker exec "$O" "$CID" psql "$@"
