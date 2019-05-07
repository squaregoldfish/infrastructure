#!/usr/bin/bash

set -Eeuo pipefail
cd "{{ drupal_home }}"

BB="{{ drupal_home }}/bin/bbclient-all"
PROJECTS=({{ drupal_websites | join(" ") }})
LOGFILE=backup.log

for project in "${PROJECTS[@]}"; do

    if [ ! -d "$project" ]; then
        echo "$project directory not found. Skipping." >> "$LOGFILE"
        continue
    fi

    cd "$project/drupal"

    docker-compose down
    $BB create --verbose --stats "::$project-{now}" . >> "$LOGFILE"
    docker-compose up -d

    cd "{{ drupal_home }}"

done
