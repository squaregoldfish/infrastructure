#!/bin/bash
# Attempt to retrive the original of a file installed using a package manager.
# Useful when you've edited a file (usually a config file) and want to see what
# the original looked like. Will work on directories as well. Tested on Centos
# and Ubuntu.
# Use like this: retrieve-original file-or-dir extract-to-here

set -u
set -e

if [ $# -lt 2 ]; then
	echo "usage: $0 source target"
	exit 1
fi

source=$(readlink -f "$1")
target=$(readlink -f "$2")
basename=$(basename "$source")

if [ -e "$target/$basename" ]; then
	echo "$target/$basename already exists"
	exit 1
fi


ubuntu () {
	pkg=$(dpkg -S "$source" | sed 's/:.*//')
	tmp=$(mktemp -d /tmp/retrieve-original.XXXXXX)
	trap 'rm -rf "$tmp"' EXIT
	cd "$tmp"
	apt-get download -qq "$pkg"
	ar xf ./*.deb
	tar xfJ data.tar.xz
	rel=${source#/*}
	mv "$rel" "$target"
	echo "Extracted $basename from $pkg to $target"
}


centos () {
	pkg=$(rpm -qf "$source")
	tmp=$(mktemp -d /tmp/retrieve-original.XXXXXX)
	trap 'rm -rf "$tmp"' EXIT
	cd "$tmp"
	yumdownloader "$pkg" > /dev/null
	rpm2cpio -- *.rpm | cpio --quiet -idm
	rel=${source#/*}
	mv "$rel" "$target"
	echo "Extracted $basename from $pkg to $target"
}


if which apt-get > /dev/null 2>&1; then
	ubuntu
elif which yum > /dev/null 2>&1; then
	if ! which yumdownloader > /dev/null; then
		echo "I can find yum(1) but not yumdownloader(1), please install yum-utils"
		exit 1
	fi
	centos
else
	echo "Couldn't find apt-get(1) nor yum(1) - this script is only tested on Ubuntu and Centos"
	exit 1
fi
