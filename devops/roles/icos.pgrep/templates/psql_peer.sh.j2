#!/bin/bash
# This scripts is a psql(1), hardcoded to connect to the replication master.

set -e
cd "{{ pgrep_home }}"

# If stdout is a tty then we need the '-t' flag, otherwise we're redirecting to
# a file and we must not have "-t".
if [ -t 0 ] && [ -t 1 ]; then O="-it"; else O="-i"; fi

docker run "$O" --rm --entrypoint=/usr/bin/psql "{{ pgrep_image }}" \
	   -d '{{ pgrep_conninfo }}'
