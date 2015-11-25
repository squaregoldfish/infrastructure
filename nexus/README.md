Sonatype Nexus Docker for artifact repositories
=============================
`docker-compose.yml` to start a Docker container with the Sonatype Nexus repository.

Deploying a Nexus instance
--------------------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `nexus/example.docker-compose.yml` named `docker-compose.yml` in the same folder, then edit it as needed.
- When editing `docker-compose.yml`, among other things, make sure to mount a host directory to be used as Nexus data folder. This should make the Docker container disposable.
- Run `docker-compose up -d`.

