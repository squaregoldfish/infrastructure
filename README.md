Deployment and development tools for ICOS Carbon Portal services
====================================================

Deployment and provisioning of CP services is automated using Ansible.
All related configurations and definitions are found in `devops` folder of this repository.

Some of CP's own, in-house-developed, services, are built, packaged and deployed using SBT build tool. Source code of CP-specific SBT plugins can be found in folder `sbt`.

Other folders in this Git repository mostly contain legacy Docker files (used before the Ansible era).

Getting started (common)
===============
To get started, one needs:
- Ubuntu 20.04 LTS or an equivalent Linux distribution
- Git
- Docker
- docker-compose
- pip
- Ansible

To install all of the above, run

`sudo apt install git docker-io docker-compose python-pip`

followed by

`pip install --user ansible==2.9.4`

(the recommended Ansible version will keep changing, so check with the team which one is relevant)

Getting started (Scala services)
===

To develop/build/deploy Scala-based services, install Java with

`sudo apt install openjdk-11-jdk`

and SBT by following the instructions on https://www.scala-sbt.org/

---
rdflog
-------
Needed by the `meta` service to be run locally on developer's machine. First, obtain the latest rdflog backup from `fsicos.lunarc.lu.se`.

`borg list /disk/data/bbserver/repos/fsicos.lunarc.lu.se/pgrep_rdflog/default/ | tail`

`borg extract /disk/data/bbserver/repos/fsicos.lunarc.lu.se/pgrep_rdflog/default/::2020-03-24T04:43:20`

`tar cvfz rdflog_volumes.tar.gz volumes/ && rm -rf volumes/`

Copy `rdflog_volumes.tar.gz` to a folder on your machine, for example with

`scp fsicos2.lunarc.lu.se:/root/rdflog_volumes.tar.gz .`

(Delete the archive from the server afterwards)

Extract the rdflog Postgres data with `tar xfz rdflog_volumes.tar.gz`

Disable Postgres replication-slave behavior by `rm volumes/data/recovery.conf`

`docker run --name rdflog -v <abs_path_to_here>/volumes/data:/var/lib/postgresql/data -p 127.0.0.1:5433:5432 -d postgres:10.7`

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

To see all parents and direct children of a process:
`pstree -p -s <pid>`

Working dir of a process by id:
`pwdx <pid>`

Restheart
---------

Specify aggregations for a collection:

`curl -H "Content-Type: application/json" --upload-file dobjAggrs.json http://127.0.0.1:8088/db/dobjdls`

Users that specified ORCID ID in their user profile:

`curl -G --data-urlencode 'keys={"_id":1, "profile.orcid":1}' --data-urlencode 'filter={"profile.orcid":{"$regex": ".+"}}' http://127.0.0.1:8088/db/users?count=true`

Get download counts per IP address:

`curl -o page1.json 'https://restheart.icos-cp.eu/db/dobjdls/_aggrs/perIp?pagesize=1000&page=1'`

Transform download counts json from the previous command to tsv (requires jq installed):

`cat page1.json | jq -r '._embedded[] | [.count, .ip, .megabytes] | @tsv' > page1.tsv`

Sort the results by download count descending:

`cat page1.tsv page2.tsv | sort -nr > icos_dl_stats_2018-03-27.tsv`
