#!/bin/bash

if [ "$1" ]
then subproject="$1" 
else
	echo 'Must specify a subproject, for example "thredds"'
	exit 1
fi

if [[ "$2" ]]; then branch="$2"; else branch='master'; fi
repo='git@github.com:ICOS-Carbon-Portal/infrastructure.git'

git init
git remote add -f origin git@github.com:ICOS-Carbon-Portal/infrastructure.git
git config core.sparsecheckout true
echo "$subproject"/ >> .git/info/sparse-checkout
git pull origin "$branch"
rm -- "$0" # delete itself
