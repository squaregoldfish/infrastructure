#!/bin/bash

cd "$(dirname "$0")"
source params.sh

params=''
for i in "$@";do
    params="$params \"${i//\"/\\\"}\""
done;

docker exec "$PREFIX"_drupal_1 /bin/bash -c "cd /var/www/icos-infrastructure.eu/current; drush $params"
