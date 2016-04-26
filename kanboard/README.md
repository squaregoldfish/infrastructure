Kanboard
=============================

Deploying a Kanboard instance
--------------------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `kanboard/example.docker-compose.yml` named `docker-compose.yml` in the same folder, then edit it as needed.
- When editing `docker-compose.yml`, among other things, make sure to mount a host directory to be used as Kanboard data folder. This will make the Docker container disposable.
- Make the host volume writeable to the Kanboard container's nginx user (id=100), for example: `chown 100 /disk/data/kanboard/data` .
- Run `docker-compose up -d`.

