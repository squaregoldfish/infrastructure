# Docker image and container config for access to EUDAT services

Based on irods/icommands image, which is in turn based on Ubuntu 14.04 Trusty LTS
Contains iRODS iCommands and globus-url-copy

## Deployment and usage

Docker 1.11 and `docker-compose` 1.6 or later are needed (the config file is of version 2).

- Checkout this folder to the production machine
- Copy `example.docker-compose.yml` to `docker-compose.yml` and modify the latter according to your needs
- For iCommands, copy `example.irodsEnv.txt` to `irodsEnv.txt` and modify the latter according to your needs as well
- Build the image and create a container with `docker-compose create` while in this directory
- Copy the proxy certificate into the container like so: `docker cp /tmp/x509up eudat_eudat_1:/tmp`
- Run an interactive Bash shell inside the containder with `docker start -ai eudat_eudat_1` (container will stop on exit)
- Initialize iRODS iCommands, if needed (inside the container's shell): `iinit` (will prompt for the password)
