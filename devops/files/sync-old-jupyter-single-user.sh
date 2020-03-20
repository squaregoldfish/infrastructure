#!/bin/bash

set -x
set -Eueo pipefail

user="${1:-}"
shift;

[ -n "$user" ] || { echo "sync_single_user username [rsync opts]"; exit 1; }

uid="$(( 1000000 + $(lxc exec jupyter -- id -u $user)))"
gid="$(( 1000000 + $(lxc exec jupyter -- id -g $user)))"

cd /disk/data/jupyter/old_jupyter_from_fsicos1

rsync "$@" -avz --no-owner --no-group "fsicos.lunarc.lu.se:/disk/data/jupyter/jupyter/storage/$user/" "./jupyter/storage/$user/"
rsync "$@" -avz --no-owner --no-group "fsicos.lunarc.lu.se:/disk/data/jupyter3/jupyter3/storage/$user/" "./jupyter3/storage/$user/"

chown -R "$uid:$gid" "./jupyter/storage/$user/" "./jupyter3/storage/$user/"
