Docker files for various ICOS Carbon Portal services
====================================================

alfresco
--------
Alfresco document management system, deployed at https://docs.icos-cp.eu

drupal
------
ICOS Drupal installation, deployed at https://www.icos-ri.eu/  
Was developed for ICOS by Aleksi Johansson from [Wunderkraut](http://wunderkraut.com/)

nexus
-----
Sonatype Nexus OSS installation, deployed at https://repo.icos-cp.eu . Maven/Ivy/npm artifact repository manager.

rdflogdb
--------
PostgreSQL installation used to persist Carbon Portal's metadata database's RDF assertion/retraction log.
Used internally by the [meta](https://github.com/ICOS-Carbon-Portal/meta) project.

thredds
-------
Unidata's THREDDS Data Server, deployed at http://thredds.icos-cp.eu


Getting started
===============
To get started, one needs:  
- Linux
- Git
- Docker
- docker-compose

To avoid cloning the whole `infrastructure` repository, one can use Git's sparse checkouts.
To automate sparse cloning you can use the `sparse.sh` script from the root of this repo.
Run the following from a newly created folder for your new repo:

`wget https://github.com/ICOS-Carbon-Portal/infrastructure/raw/master/sparse.sh`  
`chmod +x sparse.sh`
`./sparse.sh <subproject> [<branch>]` (default branch is `master`)

`subproject` above must be one of the first-level folders in this repo.


Useful commands
===============

To get a list of Docker container IDs together with their Linux process IDs (run as root):
`docker ps | awk '{print $1}' | tail -n +2 | xargs docker inspect -f '{{ .Config.Hostname }} {{ .State.Pid }}'`

To purge unused Docker images:
`docker rmi $(docker images --filter "dangling=true" -q --no-trunc)`

To get a list of top 10 processes by memory usage:
`ps aux --sort -rss | head -n 10`

To get process' command:
`ps -fp <pid>`

Working dir of a process by id:
`pwdx <pid>`
