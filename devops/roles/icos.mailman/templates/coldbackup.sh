#!/bin/bash
# Shut down mailman. Do backup. Start it up again.

set -Eeo pipefail

cd /docker/mailman

if [[ -z $1 ]]; then
    ARCHIVE="test-{now}"
else
    ARCHIVE="$1-{now}"
fi

BUILD_INFO=$PWD/volumes/build.info
trap 'rm -f $BUILD_INFO' EXIT

# Dump information about which images were running. This is not so
# much for disaster recovery as it is for quickly rolling back a
# failed deployment.
docker-builds > "$BUILD_INFO"

docker-compose down

bin/bbclient-all create --verbose --stats "::$ARCHIVE" volumes

docker-compose up -d
