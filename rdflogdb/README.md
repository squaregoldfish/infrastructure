PostgreSQL Docker for RDF log
=============================
`docker-compose.yml` for a Postgres instance dedicated for holding RDF update log: the historic log of every RDF triple assertion and retraction. This log will be used as the persistence method for the ICOS metadata service. Additionaly, using this log, the ICOS metadata service will be able to recover a state it had at any point in time in the past.

Deploying an RDF log Postgres instance
--------------------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `rdflogdb/example.docker-compose.yml` named `docker-compose.yml` in the same folder, then edit it as needed.
- When editing `docker-compose.yml`, among other things, make sure to mount a host directory to be used as Postgres data folder. This will make the Docker container disposable.
- Run `docker-compose up -d`.
- There are at least two backup options: either rsync the database data folder, or make database dumps.