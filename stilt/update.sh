#!/bin/bash
# 1. Modify the stiltrun role to use the latest built stilt image
# 2. Copy that the image to remote locations

DEFAULTS=../devops/roles/icos.stiltrun/defaults/main.yml
MAX_AGE_MIN=60


function most_recent_build {
	find . -name 'stilt*-*.tgz' -mmin -"$MAX_AGE_MIN" -printf '%T@\t%p\0' |
		sort -zk 1nr | tr '\0' '\n' | head -1 | cut -f 2
}


function get_version {
	sed -nE "s/^stiltrun_image_id.*: (.*)/\1/p" < "$DEFAULTS"
}

	
function update_defaults {
	sed -i -E \
		-e "s/^(stiltrun_image_id.*): .*/\1: $1/"\
		-e "s/^(stiltrun_image_url.*custom).*tgz$/\1-$1.tgz/"\
		"$DEFAULTS"
}


FILE=$(most_recent_build)
if [ -z "$FILE" ]; then
	echo "Could not find any recent (max $MAX_AGE_MIN minutes) build."
	exit 1
fi

# ./stiltcustom-0f96e3e9f93f.tgz => 0f96e3e9f93f
NEW="${FILE:${#FILE}-16:12}"

OLD=$(get_version)
if [[ "$NEW" == "$OLD" ]]; then
	echo "Version hasn't changed"
	exit 0
else
	update_defaults "$NEW"
	echo "Updated $DEFAULTS from $OLD to $NEW"
	scp "$FILE" "fsicos.lunarc.lu.se:/usr/share/nginx/static/share/docker/stilt/stiltcustom-$NEW.tgz"
fi

