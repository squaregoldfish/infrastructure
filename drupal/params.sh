#!/bin/bash

cd "$(dirname "$0")"
prefixFile=`pwd`'/docker/name-prefix.txt'

if [ -e "$prefixFile" ]
then
	PREFIX=`cat "$prefixFile"`
#	echo Container name prefix will be "$PREFIX"
else
	echo "$prefixFile"' not found!'
	exit 1
fi
