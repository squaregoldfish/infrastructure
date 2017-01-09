date
export STILT_NAME=$1
echo $STILT_NAME
export STILT_YEAR=$2
echo $STILT_YEAR
export RUN_ID=$3
echo $RUN_ID
R CMD BATCH --no-restore --no-save --slave stiltR/stilt.r stilt.${STILT_NAME}${STILT_YEAR}${RUN_ID}.log
date
R CMD BATCH --no-restore --no-save --slave reform_csv.r reform_csv.${STILT_NAME}${STILT_YEAR}${RUN_ID}.log
date
