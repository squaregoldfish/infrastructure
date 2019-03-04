#!/bin/bash

set -Eeo pipefail

function dcomp { docker-compose -f docker-compose.yml "$@"; }
function abort { >&2 echo "$@"; exit 1; }
function is_running { dcomp top | grep -q postgres; }
function not_connected_to_peer {
    ./ctl logs | tail -n 1 |
	grep -q 'Connecting to peer and making sure that our replication slot exists';
}

cd "{{ pgrep_home }}"

case "${1:-}" in
    "" | "help")
	echo "usage: ctl [cmd]"
	echo ""
	echo "where [cmd] is one of:"
	echo "  help    - this text"
	echo "  shell   - start a shell in the running container"
	echo "  status  - database/replication status"
	;;
    "shell") dcomp exec db bash -i ;;
    "status")
	if ! is_running; then abort "postgres is not running, try './ctl up'"
	elif not_connected_to_peer; then abort "postgres is up but not connected to its peer"
	else ./psql -q < .status.sql; fi
	;;
    *)
	abort "unknown subcommand - try 'help'"
	;;
esac
