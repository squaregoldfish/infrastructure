#!/bin/bash
for STATION in CB4 HEI MHD PAL BI5 OX3 LU1 GIF HPB HU1 JFJ PUY SIL TR4
do 
nohup ./start.stilt.sh ${STATION} 20110101 20111231 > ${STATION}_2011.log &
done
