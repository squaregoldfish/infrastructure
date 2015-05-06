#!/bin/bash

# Check that environment argument is supplied.
if [ "$1" ]
then
    if [ "$1" == "up" ]
    then
        cd docker
        docker-compose -p icos up -d
    elif [ "$1" == "start" ]
    then
        cd docker
        docker-compose -p icos start
    elif [ "$1" == "stop" ]
    then
        cd docker
        docker-compose -p icos stop
    elif [ "$1" == "rm" ]
    then
        cd docker
        docker-compose -p icos rm
    elif [ "$1" == "purge" ]
    then
        while true; do
            read -p "Are you sure? " yn
            case $yn in
                [Yy]* ) break;;
                [Nn]* ) exit;;
                * ) echo "Please answer 'Yes' or 'No'.";;
            esac
        done
        if [ "$2" == "drupal" ]
        then
            echo "Purging..."
            if [ -d "drupal/builds" ]
            then
                chmod -R 777 drupal/builds
                rm -rf drupal/builds
            fi
            if [ -d "drupal/current" ]
            then
                chmod -R 777 drupal/current
                rm -rf drupal/current
            fi
            if [ -d "drupal/_build" ]
            then
                chmod -R 777 drupal/_build
                rm -rf drupal/_build
            fi
            if [ -d "drupal/files" ] && [ "$3" == "new" ]
            then
                chmod -R 777 drupal/files/*
                rm -rf drupal/files/*
            fi
        else
            echo "Service needed as second argument. Try 'drupal' for example. Purge cancelled."
        fi
    elif [ "$1" == "bash" ]
    then
        if [ "$2" ]
        then
            if [ "$2" == "drupal" ]
            then
                docker exec -ti icos_drupal_1 /bin/bash
            elif [ "$2" == "mariadb" ]
            then
                docker exec -ti icos_mariadb_1 /bin/bash
            fi
        else
            echo "Service needed as second argument. Try 'drupal' for example."
        fi
    elif [ "$1" == "build" ]
    then
        if [ "$2" ]
        then
            if [ "$2" == "drupal" ]
            then
                # Purge drupal here because it doesn't work from inside
                # the container on OS X because of some NFS issue.
                if [ "$3" == "new" ] || [ "$3" == "existing" ]
                then
                    echo "This is going to purge drupal. "
                    ./docker.sh purge drupal
                fi
                docker exec icos_drupal_1 /bin/bash -c "cd /var/www/icos-infrastructure.eu; ./build.sh $3"
                # Make sure the files are owned by the correct user.
                docker exec icos_drupal_1 /bin/bash -c "chown -R icos-admin:icos-admin /var/www/icos-infrastructure.eu"
            fi
        else
            echo "Service needed as second argument. Try 'drupal' for example."
        fi
    else
        echo "Command not found. Try 'up' for example."
    fi
else
    echo "Command needed as argument. Try 'up' for example."
fi