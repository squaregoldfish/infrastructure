date
export STILT_NAME=$1
echo $STILT_NAME
export RUN_ID=$2
echo $RUN_ID
R CMD BATCH --no-restore --no-save --slave stiltR/stilt.r stilt.${STILT_NAME}${RUN_ID}.log
date
#R CMD BATCH --no-restore --no-save --slave reform_csv.r reform_csv.${STILT_NAME}${RUN_ID}.log
date
