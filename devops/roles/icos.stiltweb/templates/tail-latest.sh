#!/bin/bash
# Tail debug logs of stiltweb and stiltcluster. This include the various trace
# files as well as the systemd services.

set -e
set -u

SDIR="{{stiltweb_statedir}}"
# The debug logs that stiltweb produces
LOGS=("$SDIR/slotproducer.log" "$SDIR/slots/trace.log" "$SDIR/jobs/trace.log")

# Create background processes that will direct journactl output to temp files.
 for service in stiltweb stiltcluster; do
	L="$HOME/.$service-journal-output"
	# remove old log
	rm -f "$L"
	# start background process to fill log
	journalctl -qlfu "$service" > "$L" &
	# append to list
	LOGS+=("$L")
done

# Cleanup on exit, stop process and remove temp files.
trap 'rm -f -- $HOME/.*-journal-output; kill $(jobs -p)' EXIT

# Usually we have a stiltcluster node running on the same machine as well, it
# might be instructive to see what it's doing.
C="/home/stiltcluster/workmaster.log"
if [ -f "$C" ]; then
	LOGS+=("$C")
fi

# Unless the installation is very new, there should be a job directory.
J="$(ls -dtr1 $SDIR/jobs/job*/trace.log | tail -1)"
if [ -f "$J" ]; then
	LOGS+=("$J")
fi

tail -f "${LOGS[@]}"
