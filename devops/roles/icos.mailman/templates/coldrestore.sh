#!/bin/bash

set -Eeo pipefail

cd /docker/mailman

if [[ -z $1 ]]; then
    echo 'usage: coldrestore name'
    echo '  run "make listbackup" to find the candidates'
    exit 1
fi

for d in volumes.previous volumes.restoring; do
    if [[ -e "$d" ]]; then
	1>&2 echo "The directory '$d' already exists - aborting."
	exit 1
    fi
done

echo 'Renaming volumes to volumes.previous.'

mkdir volumes.restoring
cd volumes.restoring
bin/bbclient extract "::$1" --strip-components 1

read -r -p "Restore complete. Restart mailman?" ans
if [[ "$ans" != "y" ]]; then
    echo "Aborting. Leaving restored backup in volumes.restoring"
    exit 1
fi

docker-compose down
mv volumes volumes.previous
mv volumes.restoring volumes
docker-compose up -d
