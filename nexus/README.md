Sonatype Nexus Docker for artifact repositories
=============================
`docker-compose.yml` to start a Docker container with the Sonatype Nexus repository.

Deploying a Nexus instance
--------------------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `nexus/example.docker-compose.yml` named `docker-compose.yml` in the same folder, then edit it as needed.
- When editing `docker-compose.yml`, among other things, make sure to mount a host directory to be used as Nexus data folder. This will make the Docker container disposable.
- Run `chown -R 200 <mounted host directory path>` to make sure Nexus will have write permissions to the storage folder (it will be run with UID 200 within the container).
- Run `docker-compose up -d`.

