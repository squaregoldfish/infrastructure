#!/bin/bash

set -e
set -u

if [ $# -ne 4 ]; then
  echo "usage: flexpart start    end       n outputname"
  echo "       flexpart 2012-1-1 2012-3-31 1 station1_20120101"
  echo "$@"
  exit 1;
fi

OUTPUT="/flexpart/output/$4"
mkdir -p "$OUTPUT"
cd /flexpart

set -o pipefail
if flextraset -s "$1" -e "$2" -r "$3" -o "$OUTPUT" -f candidate_sites.txt 2>&1\
	   | tee "$OUTPUT/flextraset.log"; then :
else
	touch "$OUTPUT/failure"
	exit 1
fi

touch "$OUTPUT/start"
if nice flexpart 2>&1 | tee "$OUTPUT/flexpart.log"; then
	cd "$OUTPUT"
	touch success
	rm -f -- ./partposit*
	exit 0
else
	touch "$OUTPUT/failure"
	exit 1
fi
