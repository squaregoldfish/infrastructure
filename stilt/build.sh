#! /bin/bash
#Edited by Mitch

NETCDFLIB=/usr/lib
NETCDFINCLUDE=/usr/include

SOURCES=(getfossEUnetCDF.f90 getTM3bin.f90 getTM3CH4bin.f90 getvegfracNetCDF.f90 getMODISnetCDF.f90 getEmisnetCDF.f90 )

for M in ${SOURCES[@]}; do
    gfortran -ffree-form -ffree-line-length-none -fpic -shared -I$NETCDFINCLUDE/ \
    ${M} -o ${M/.f90/.so} \
    $NETCDFLIB/libnetcdff.so $NETCDFLIB/libnetcdf.so
    echo $M done $'=====\n'
done
