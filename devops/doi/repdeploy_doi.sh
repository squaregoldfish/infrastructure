#!/bin/bash
# Redeploy DOI to the production server by ensuring that the required files
# exist and then invoking an ansible script.

set -u
set -e

trghost="fsicos.lunarc.lu.se"
docheck="--check"

if [[ $# -ge 1 && $1 = "-f" ]]; then
	docheck=""
	shift
fi

if [[ $# -lt 1 ]]; then
	echo "usage: redeploy_doi [-f] top-of-doi-repository [$trghost]"
	exit 1
fi

if [[ ! -d "$1" ]]; then
	echo "$1 is not a directory."
	exit 1
fi

if [[ $# -ge 2 ]]; then
	trghost="$2"
fi

repodir="$1"
appconf=$(realpath "$repodir/application.conf")
jarfile=$(realpath "$repodir/jvm/target/scala-2.11/doi-jvm-assembly-0.1-SNAPSHOT.jar")
thisdir=$(dirname "$0")
ymlfile=$(realpath "$thisdir/setup_doi.yml")

if [[ ! -f $appconf ]]; then
	echo "Cannot find application.conf in $repodir. application.conf should be in the doi"\
		 "repository's root directory. "
	exit 1
fi

if [[ ! -f $jarfile ]]; then
	echo "I found application.conf in $repodir, but the assembly jarfile is missing"\
		 "($jarfile). Maybe run \"sbt assembly\" and then try again?"
	exit 1
fi

if [[ ! -f $ymlfile ]]; then
	echo "There should be a $ymlfile !?. Aborting."
	exit 1
fi

ansible-playbook $docheck -i "$trghost", "$ymlfile" --ask-sudo \
				 -e doi_app_conf="$appconf"					   \
				 -e doi_jar_file="$jarfile"

if [[ $docheck != "" ]]; then
	echo "If the above looked reasonably, then rerun the script with -f as first argument."
fi
