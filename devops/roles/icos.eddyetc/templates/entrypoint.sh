#!/bin/bash

set -euo pipefail

USAGE_NAME="{{ eddyetc_bin_path | basename }}"
INPUT_FILE="{{ eddyetc_input_file }}"

abort () { echo "$@" >&2; exit 1; }

if [ $# -ne 1 ]; then
	abort "usage: ${USAGE_NAME} name_of_output_file.zip"
fi


if [ ! -f "$INPUT_FILE" ]; then
	abort "$INPUT_FILE is missing"
fi

cd /workdir
Rscript "{{ eddyetc_r_name }}"

if [ -e output ]; then
	zip -qr "/output/${1}" output
else
	abort 'R script produced no output!'
fi

	

