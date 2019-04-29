# Overview

This installs the Nexus Repository Manager, a software that serves jar files.
It installs version 2 of Nexus, running as a docker container.


## Installing

Run a simple ansible playbook that looks like this:

	- hosts: icosprod2
	  become: true
	  roles:
		- icos.nexus

Then log in to the web management GUI and change the password (there is no
configuration option in the base image to change the password during
installation).

If restoring from a backup, the previously configured password is used
automatically.


## Resources

https://hub.docker.com/r/sonatype/nexus

https://github.com/sonatype/docker-nexus/issues

https://repo.icos-cp.eu/nexus/
