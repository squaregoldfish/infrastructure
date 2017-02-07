date
cd /opt/STILT_modelling/
export RUN_ID=$4
export STILT_NAME=$1
export START_DATE=$2
export END_DATE=$3
[[ -z ${RUN_ID} ]] && RUN_ID=RUN
echo $RUN_ID
echo $STILT_NAME
echo $START_DATE
echo $END_DATE
[[ ! -d ${RUN_ID} ]] && mkdir ${RUN_ID} || ( rm -f ${RUN_ID}/FAILURE ; rm -f ${RUN_ID}/SUCCESS ) 
R CMD BATCH --no-restore --no-save --slave prepare_input.r ${RUN_ID}/prepare_input.${STILT_NAME}${RUN_ID}.log || ( touch $RUN_ID/FAILURE ; cat ${RUN_ID}/prepare_input.${STILT_NAME}${RUN_ID}.log >> $RUN_ID/FAILURE )
[[ -f ${RUN_ID}/FAILURE ]] && cat ${RUN_ID}/run*.log >> $RUN_ID/FAILURE
date
