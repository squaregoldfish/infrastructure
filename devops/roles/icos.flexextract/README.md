# Overview

This role will install the flexextract software.

The code itself is not in this role. When running the role a variable must be
set that points to the code.


## How to use this role

First download the docker_flexpart and put it in /tmp.

Then run a playbook that looks like:

	- hosts: flexextract
	  vars:
		flexextract_src_dir: /tmp/docker_flexpart
	  roles:
		- icos.flexextract


The role will then:
  + Create a flextract user
  + Build the flexextract image
  + Create a 'flexextract' script that runs the image

Once the role is installed, switch to the flexextract user and run the script

	$ su flexextract
	$ flexextract 20190201
	[lots and lots of output]
	$ ls -l download
	[downloaded data files]
