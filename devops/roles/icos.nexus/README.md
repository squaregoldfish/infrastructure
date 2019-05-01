# Overview

This role installs the Sonatype Nexus Repository Manager, a software that
serves jar files, mostly for use while building our scala software using
sbt. It installs version 2 of Nexus, running as a docker container.


## Deployment

Run a simple ansible playbook that looks like this:

	- hosts: icosprod2
	  become: true
	  roles:
		- icos.nexus

Then log in to the web management GUI and change the password from the default
(as provided n the documentation). There is no configuration option in the base
image to change the password during installation.

If restoring from a backup, the previously configured password is used
automatically.


## Fine-grained deployment

Especially during testing and upgrades, it's useful to be able to deploy just
parts of the role. For that purpose, the role acceps a number of boolean
variables to selectively disable functionality. Starting with a playbook
looking like the following and adapt as necessary:

	- hosts: all
	  become: true
	  vars:
		nexus_docker_enable: True
		nexus_nginx_enable: True
		nexus_bbclient_enable: True
	  roles:
		- icos.nexus


## How to test a deployment using sbt in a ICOS-CP environment

1. Create the file ~/.ivy2/.credentials

		realm=Sonatype Nexus Repository Manager
		host=repo.icos-cp.eu
		user=deployment
		password=SECRET

2. Run sbt in the data project

		$ cd icos/data
		$ sbt
		# Test pulling jars from nexus
		sbt:data> update
		# Switch to netcdf subproject and test pushing to nexus
		sbt:data> project netcdf
		sbt:data-netcdf> publish


## Problems upgrading from 2.11 to 2.14

2019-04-30

Nexus 2.14 requires that all urls start with "/nexus".
  + It'll give a 404 for the root url, '/nexus' will work.
  + The status url '/service/local/status' needs to be '/nexus/service/local/status'
  + etc etc etc

+ Whether this is a configuration issue has not been properly investigated.
+ A simple NGINX rewrite of URLs will for for all GETs, put sbt's 'publish'
  command will use POST and those don't work with NGINX using 302 error
  messages for URL rewrites.


## Problems upgrading from 2.11 to 3.x

2019-05-01 - Just blindly upgrading - i.e deploying a docker images using
nexus3 on top of existing nexus2 volume data - will not work. No further
investigation has been done.


## Resources

+ [Official documentation](https://help.sonatype.com/repomanager2)
+ [How to upgrade between versions](https://help.sonatype.com/repomanager3/upgrading)
+ [Docker tags](https://hub.docker.com/r/sonatype/nexus)
+ [Bugtracker](https://github.com/sonatype/docker-nexus/issues)
