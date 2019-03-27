#!/bin/bash

set -Eeo pipefail

cd "{{ cpmeta_home }}"

if [[ -z "${1:-}" ]]; then
    ARCHIVE="test-{now}"
else
    ARCHIVE="$1-{now}"
fi

export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes

./bin/bbclient-all create --verbose --stats "::$ARCHIVE" "{{ cpmeta_filestorage_target }}"
