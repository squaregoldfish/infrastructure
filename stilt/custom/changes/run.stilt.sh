#!/bin/bash

pids=""
FAIL=0

export STILT_NAME=$1
echo STILT_NAME $STILT_NAME
export STILT_YEAR=$2
echo STILT_YEAR $STILT_YEAR
export RUN_ID=$3
echo RUN_ID $RUN_ID
export PART2=$4
echo PART2 $PART2

rm -f $RUN_ID/FAILURE
rm -f $RUN_ID/SUCCESS
cp -r STILT_Exe $RUN_ID/.

PART1=1
TOTPART=${PART2}

LF="" # log file information (additional information in the log file name (e.g. station name
OFFSET=0

[[ ! -d Runs.done ]] && mkdir Runs.done
[[ ! -d ${RUN_ID}/Runs.done ]] && mkdir -p ${RUN_ID}/Runs.done

for P in `seq $PART1 $PART2`; do
    if  [[  ${PART1} == 1 ]]; then
	echo -n submitting STILT part $P of ${TOTPART}"... "
    else
	echo -n submitting STILT part $P of ${TOTPART} starting at ${PART1} "... "
    fi

    let P_O=$P+$OFFSET
    PF="`printf %2.2i $P_O`"
    export STILT_PART=$P
    export STILT_TOTPART=$TOTPART
    export STILT_OFFSET=$OFFSET
    date
    nohup R CMD BATCH --no-restore --no-save --slave stiltR/stilt.r ${RUN_ID}/stilt_${PF}${LF}.${STILT_NAME}${STILT_YEAR}${RUN_ID}.log > ${RUN_ID}/nh_${PF}${LF}.log 2>&1&
    pids="$pids $!"
done

for pid in $pids ; do
    echo Process ID $pid
#    ps -p $pid -o comm=
    wait $pid 
    stat=$?
    echo exit $stat
    let FAIL=$FAIL+$stat
done
echo $FAIL runs failed

if [ "$FAIL" == "0" ];
then
    echo reform time series
    R CMD BATCH --no-restore --no-save --slave reform_csv.r ${RUN_ID}/reform_csv.${STILT_NAME}${STILT_YEAR}${RUN_ID}.log && touch $RUN_ID/SUCCESS || touch $RUN_ID/FAILURE
    echo exit $?
else    
    touch $RUN_ID/FAILURE
    exit 1
fi

date
