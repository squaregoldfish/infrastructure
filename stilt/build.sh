#!/bin/bash
# 1. Build the base stilt image.
# 2. Build the custom stilt image.
# 3. Save the custom stilt image as a tarball.
# 4. Save a log file

set -eux
set -o pipefail

TAG_BASE=${TAG_BASE:-stiltbase}
TAG_CUSTOM=${TAG_CUSTOM:-stiltcustom}

LOG=$(mktemp /tmp/build-stilt.XXX)
chmod o-r "$LOG"

function vault {
    val=$(cd .. && ansible-vault decrypt --output - vault.yml | 
                 awk "\$1 ~ /^$1/ { print \$2 }")
    if [[ -z "$val" ]]; then
        1>&2 echo "Could not find value for $1"
        exit 1
    fi
}

if [[ "${JENASVNUSER+set}" != set ]]; then
    JENASVNUSER=$(vault vault_stilt_jena_user)
fi

if [[ "${JENASVNPASSWORD+set}" != set ]]; then
    JENASVNPASSWORD=$(vault vault_stilt_jena_password)
fi

ARGS=(--build-arg=JENASVNUSER=$JENASVNUSER
      --build-arg=JENASVNPASSWORD=$JENASVNPASSWORD)

docker build --no-cache --pull --tag="$TAG_BASE" "${ARGS[@]}" base | tee "$LOG"

DOCKERFILE="$PWD/custom/Dockerfile.tmp"
trap 'rm -f -- "$DOCKERFILE"' EXIT
sed "s/^FROM.*/FROM $TAG_BASE/" custom/Dockerfile > "$DOCKERFILE"

docker build --no-cache --tag="$TAG_CUSTOM" -f "$DOCKERFILE" custom | tee -a "$LOG"

CUSTOM_ID=$(docker images | awk "\$1 ~ /^$TAG_CUSTOM\$/ { print \$3 }")
OUTPUT_FN="$TAG_CUSTOM-$CUSTOM_ID.tgz"

docker save "$TAG_CUSTOM" | gzip -c > "$OUTPUT_FN"
echo "$OUTPUT_FN"
echo "$LOG"
