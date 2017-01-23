PostgreSQL Docker for RDF log
=============================
`docker-compose.yml` for a Postgres instance dedicated for holding RDF update log: the historic log of every RDF triple assertion and retraction. This log will be used as the persistence method for the ICOS metadata service. Additionaly, using this log, the ICOS metadata service will be able to recover a state it had at any point in time in the past.

Deploying an RDF log Postgres instance
--------------------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `rdflogdb/master/build/example.init-db.sh` named `init-db.sh` in the same folder, then edit it as needed.
- Make a copy of `rdflogdb/master/.example.env` named `.env` in the same folder, then edit it as needed.
- When editing `docker-compose.yml`, among other things, make sure to mount a host directory to be used as Postgres data folder. This will make the Docker container disposable.
- Run `docker-compose up -d`.
- There are at least two backup options: either make database dumps or use a postgres slave.

(Optional) Deploying a Postgres slave
-------------------------------------
- Make a copy of `rdflogdb/slave/build/example.recovery.conf` named `recovery.conf` in the same folder, then edit it as needed.
- Make a copy of `rdflogdb/slave/.example.env` named `.env` in the same folder, then edit it as needed.
- Create system account on slave machine for ssh tunnel coming from master
- Setup service for ssh tunnel from master based on `rdflogdb/master/example.postgrestunnel.service`
- Edit and run `rdflogdb/slave/init.sh` to start container as slave. Note that `rdflogdb/slave/init.sh` should only be run once when you setup postgres container to act as slave.
