date
cd /opt/STILT_modelling/
export RUN_ID=$4
export STILT_NAME=$1
export START_DATE=$2
export END_DATE=$3
echo $RUN_ID
echo $STILT_NAME
echo $START_DATE
echo $END_DATE
R CMD BATCH --no-restore --no-save --slave prepare_input.r prepare_input.${STILT_NAME}${RUN_ID}.log
date
