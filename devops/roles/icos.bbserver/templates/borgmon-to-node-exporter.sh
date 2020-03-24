#!/bin/bash
# Invoke borgmon and write the results to the node_exporter's textfiles
# directory.

set -Eueo pipefail

textfiles="{{ bbserver_textfiles }}"

if [ ! -d "$textfiles" ]; then
    echo "the textfiles directory at '$textfiles' does not exist"
    exit 1
fi

# https://github.com/prometheus/node_exporter#textfile-collector
# First write to a files suffixed with our PID
"$HOME/bin/borgmon.py" > "$textfiles/bbserver.prom.$$"

# Then atomically rename it, thus exposing it to node_exporter
mv "$textfiles/bbserver.prom.$$" "$textfiles/bbserver.prom"
