#!/bin/bash
# This is the host wrapper script for the eddy etc docker image.
#
# It checks the command line arguments, builds the docker command line
# (including volumes) and then executes the eddyetc image.

set -euo pipefail

IMAGE="{{ eddyetc_image }}"
USAGE_NAME="{{ eddyetc_bin_path | basename }}"
CONTAINER_PREFIX="{{ eddyetc_container_prefix }}"
GUEST_INPUT_PATH="{{ eddyetc_input_file }}"

die () { echo "$@" >&2; exit 1; }

if [ $# -ne 2 ]; then
	die "usage: $USAGE_NAME input.zip output.zip"
fi

FULL_INPUT=$(realpath "$1")
if [ ! -f "$FULL_INPUT" ]; then
	die "Could not find $FULL_INPUT"
fi

FULL_OUTPUT=$(realpath "$2")
BASE_OUTPUT=$(basename "$FULL_OUTPUT")
if [ -f "$FULL_OUTPUT" ]; then
	die "$FULL_OUTPUT already exists, refusing to overwrite"
fi

# Create a tmp directory to mount as /output inside the container. By not
# mounting $PWD we make it easier to clean up (just remove the tmp directory at
# EXIT). Make sure to create the tmp directory next to the specified output file
# - that way final mv(1) takes place on the same file system.
TMP=$(mktemp -d "${FULL_OUTPUT}.XXXXXX")
trap 'rmdir "$TMP"' EXIT

CMD=(docker run
	 --rm
	 # Name the container after the tmp dir. This makes the container name
	 # unique while keeping the output name visible which aids debugging.
	 "--name=$CONTAINER_PREFIX${TMP##*/}"
	 -v"$TMP":/output:rw
     # The R code in the image expects to find a zip file containing its input
	 # in this hardcoded location.
	 "-v$FULL_INPUT:$GUEST_INPUT_PATH"
	 "$IMAGE"
	 "$BASE_OUTPUT"
	 )

# Execute docker - a single run is expected to take 3-6 minutes.
eval "${CMD[@]}"

# Move the output file from the tmp directory to where the user wants it.
mv "$TMP/$BASE_OUTPUT" "$FULL_OUTPUT"

