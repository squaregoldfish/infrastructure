#!/bin/bash
set -eu

if [ $# -ne 2 ]; then
  echo "usage: certbot-retrive-cert fromhost domain"
  exit 1
fi

cd /etc/letsencrypt

for d in archive renewal live; do
  rsync -av "$1:/etc/letsencrypt/$d/$2*" "./$d"
done
