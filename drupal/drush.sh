#!/bin/bash

params=''
for i in "$@";do
    params="$params \"${i//\"/\\\"}\""
done;

docker exec icos_drupal_1 /bin/bash -c "cd /var/www/icos-infrastructure.eu/current; drush $params"
