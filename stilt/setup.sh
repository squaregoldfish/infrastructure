#!/bin/bash

set -u
set -e

ID=$1

echo "setup.sh $(date) $ID" >> /tmp/setup.sh.log
#tar -C /home/ute/changes -cf - . | docker cp - $ID:/opt/STILT_modelling

tar -C /home/andre/icos/infrastructure/stilt/changes -cf - . | docker cp - $ID:/opt/STILT_modelling


