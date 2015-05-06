Drupal for ICOS
===================

## Requirements

### To run the site

Instructions on how to run the site.

#### On OS X

- vagrant (developed with version 1.7.2)
- vmware fusion (developed with version 7.1.1)
- vagrant-vmware-fusion vagrant plugin
- boot2docker 1.5 - optional, only needed if you want to command docker outside the vagrant box

#### On Linux

- docker 1.5
- docker compose 1.1.0

## Setup

### On OS X

- Create docker/docker-compose.yml file. See docker/example.docker-compose.yml for example.
- Run vagrant up
- Add the [INSTANCE_HOSTNAME] and [INSTANCE_IP] to your local machines hosts file
- Add "export DOCKER_HOST=tcp://[INSTANCE_HOSTNAME]:2375" to your shell - optional, only needed if you want to command docker outside the vagrant box
 - Note that this conflicts with other Docker environments you might have
 
### On Linux

- Create docker/docker-compose.yml file. See docker/example.docker-compose.yml for example.
- Run "./docker.sh up" on the root of the project.

### Drupal

#### Existing site content and files

- See Backup and Restore part of the Administration section of the docs.

#### Clean install

- The footer is per site and considered content (since it's content can be changed by the editors) and for that reason, not in a feature. Create new mini panel with the Three column layout with the machine name 'footer'. This way the footer is automatically placed and themed.
 
## How to get around

### On OS X

- You can access the site at [INSTANCE_HOSTNAME]

### On Linux

- You can access the site at http://localhost

## Future improvements

- Use [Docker Machine](http://docs.docker.com/machine/#vmware-fusion) instead of Vagrant and custom CentOS box 

