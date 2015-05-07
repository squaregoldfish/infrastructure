#!/bin/bash

# This file is mounted as a volume to the docker image
# so this file can be modified without rebuilding the image

# Only build the new Drupal site once
if [ ! -f /build_done ]
then
    touch /build_done
    # Build the Drupal site with build.sh
    cd /var/www/icos-infrastructure.eu
    mkdir -p files
    ./build.sh new
fi

# Make sure the file permissions are correct
chown -R icos-admin:icos-admin /var/www/icos-infrastructure.eu

# Start the services
service php-fpm start
service varnish start

# Start nginx which has daemon: off; in it's configuration
# so it will run in the foreground and keep the container running
nginx
