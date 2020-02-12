#!/bin/bash

set -euo pipefail

PATCHES=/eddyetc/patches
WORKDIR=/workdir/EC-Flux-nonICOS

mkdir -p "$WORKDIR"

cd "$WORKDIR"

if [ -d "$PATCHES" ]; then
    echo "Installing patches from $PATCHES."
    cp $PATCHES/* .
fi

echo "Now run 'Rscript nonICOS_WorkHorse.R NAME DIR'"
echo "Example:"
echo "  Rscript nonICOS_WorkHorse.R CZ-Bk1 /eddyetc/CZ-Bk1/CZ-Bk1_G3/"
exec bash -i
