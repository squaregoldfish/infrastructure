#!/bin/bash
cd /opt/STILT_modelling/
export STILT_NAME=$1
export STILT_LAT=$2
export STILT_LON=$3
export STILT_ALT=$4
export START_DATE=$5
export END_DATE=$6
export RUN_ID=$7
echo $RUN_ID
echo $STILT_NAME
echo $STILT_LAT
echo $STILT_LON
echo $STILT_ALT
echo $START_DATE
echo $END_DATE
[[ ! -d ${RUN_ID} ]] && mkdir ${RUN_ID}
exec R CMD BATCH --no-restore --no-save --slave prepare_input_norun.r ${RUN_ID}/prepare_input.${STILT_NAME}${RUN_ID}.log 
