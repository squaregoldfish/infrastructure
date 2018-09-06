#!/bin/bash
# A script that can be used as a starting point for "queueing" lots of flexpart
# simulations. It will iterate over a number of stations and try to start every
# combination of station and date.
#
# It detects when the maximum number of parallel simulations are running and
# then retries every minute.

echo "This script should be used as a starting point."
exit 1

# The fourth quarter was broken when this script was written, here is the
# commandline to be used:
# flexpart 2012-10-01 2012-12-31 1 station1_20121001

# Error messages output by flexpart - used for testing this script.
# msg="Simulation started. Output in ..."
# msg="Output directory /foo/bar already exists. Please"
# msg="The maximum number of parallel flexpart"

SLEEP=60

echo "Started at" "$(date -Iminutes)"

for ((i=1; i<=59; i++)); do
	for args in "2012-01-01 2012-03-31 $i station${i}_20120101" \
				"2012-04-01 2012-06-30 $i station${i}_20120401" \
				"2012-07-01 2012-09-30 $i station${i}_20120701";
	do
		# convert argument string into array in order to allow safe expansion
		read -r -a arga <<<"$args"
		log_retry="yes"
		while :; do
			msg=$(flexpart run "${arga[@]}")
			case $msg in
				"Simulation started"*)
					echo "$(date -Iminutes) - $args - started"
					;;
				"Output directory"*"already exists"*)
					echo "$(date -Iminutes) - $args - already existed"
					;;
				"The maximum number of parallel"*)
					if [ $log_retry = "yes" ]; then
						echo "$(date -Iminutes) - $args - max number reached, "\
							 "will retry every $SLEEP seconds"
						log_retry="no";
					fi
					sleep $SLEEP;
					continue
					;;
				*)
					echo "$(date -Iminutes) - $args - couldn't parse |$msg|"
					;;
			esac
			break
		done
	done
done


echo "Finished at" "$(date -Iminutes)"
