# Jupyterhub using dockerspawner

## Administering the hub

### Overview

The hub runs as a docker-compose project with two separate services:

1. hub - This handles authentication and spawning notebook containers.
2. proxy - Shuffles traffic from clients to either the hub or the notebooks

A client (web browser) always talks to the proxy. If the user is logged in,
traffic is redirected to the notebook, otherwise traffic goes to the hub.

Separating the hub from the proxy allows us to restart the hub without
interrupting traffic trough the proxy.

The most common reason to restart the hub is to reload it's configuration.

Once a user logs in and starts a notebook server, the hub will spawn a new
container. This is done by mounting the docker socket inside the hub.

### Useful commands

Status of the hub:

    cd /docker/jupyterhub
    docker-compose ps

Show running user notebooks:

    docker ps | grep jupyter-

Enter a user's running notebooks. This might be useful in order to troubleshoot
missing mounts etc.

    docker exec -it jupyter-username

Create a new notebook image. Once this is done, all new notebook servers will
run the new image. Existing user notebooks will not be affected.

    cp -r docker/jupyterhub/build.notebook /tmp/new.notebook
    cd /tmp/new.notebook
    emacs Dockerfile

    # build notebook, this takes between 1 minuten and two hours
    # depending on the phases of the moon.
    docker build . --tag notebook_new

    # The docker image named "notebook" is used by our hub to start
    # new notebooks, so we'll save the old image as notebook_old
    # and then tag the new one as "notebook"
    docker tag notebook notebook_old
    docker tag notebook_new notebook


## All the nasty details

### Forums
[Jupyter discourse](https://discourse.jupyter.org)
[Jupyterhub discourse](https://discourse.jupyter.org/c/jupyterhub/10)


### Notes
[The hubs database](https://jupyterhub.readthedocs.io/en/stable/reference/database.html)

[Run the proxy separate from the hub](https://jupyterhub.readthedocs.io/en/stable/reference/separate-proxy.html)

[How to reload jupyterhub configuratio (you don't)](https://github.com/jupyterhub/jupyterhub/issues/2541)

[What happens when the Hub restarts?](https://discourse.jupyter.org/t/what-happens-when-the-hub-restarts/1701)

[Offical repo for docker deployment](https://github.com/jupyterhub/jupyterhub-deploy-docker)


### Dockerspawner
Note that Systemuserspawner is simply a subclass of Dockerspawner

[dockerspawner.py source](https://github.com/jupyterhub/dockerspawner/blob/master/dockerspawner/dockerspawner.py)


### Hub configuration

The official jupyterhub image sets its WorkingDirectory to /srv/jupyterhub and
the command to start jupyterhub is typically.

    jupyterhub -f /srv/jupyterhub/jupyterhub_config.py

Dump a default configuration by running:

    jupyterhub --generate-config -f /tmp/jupyterhub_default_config.py


###  Configuration Examples
https://github.com/compmodels/jupyterhub/blob/master/jupyterhub_config.py
https://github.com/jupyterhub/jupyterhub-deploy-docker/blob/master/jupyterhub_config.py


### Articles
[Medium-size deployment of JupyterHub with docker](https://opendreamkit.org/2018/10/17/jupyterhub-docker/)
