#!/bin/bash

# Populate a directory with symlinks from station names to station coordinates.
# Once we're done, {{stiltweb_statedir}}/stations will look like:
#    HEL -> ../slots/54.18Nx007.90Ex00015
#    ...

# The base of stiltweb's slot cache. In the toplevel are directories named of
# the stations' position, e.g '54.18Nx007.90Ex00015'
SLOTS="{{stiltweb_statedir}}/slots"

# List all directories in this toplevel. We restrict the search to '*x*x*' -
# which matches '54.18Nx007.90Ex00015' - in order to filter out other
# directories that might be there.
find "$SLOTS" -maxdepth 1 -type d -iname '*x*x*' -printf '%f\0' |
	while IFS= read -d '' -r pos; do
		# Now try to find a matching Footprint file in the classic stilt
		# directory hierarchy. A match will look like
		#   {{stiltweb_stiltdir}}/Footprints/HOV/*56.44Nx008.15Ex00100*
		#
		# At which point we can link 'HOV' to '56.44Nx008.15Ex00100'
		line=$(find {{stiltweb_stiltdir}}/Footprints -name "*$pos" -print -quit)
		if [ -z "$line" ]; then
			echo "Could not translate $pos to station name."
		else
			if [[ "$line" =~ {{stiltweb_stiltdir}}/Footprints/([^/]+)/ ]]; then
				name="${BASH_REMATCH[1]}"
				path="{{stiltweb_statedir}}/stations/$name"
				if [ ! -e "$path" ]; then
					echo "Creating the $name symlink"
					ln -s "$SLOTS/$pos" "$path"
				else
					echo "$pos already points to $name"
				fi
			else
				echo "Could not parse '$line'"
			fi
		fi
	done
