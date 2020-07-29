# https://hub.docker.com/r/jupyterhub/jupyterhub/tags
#
FROM jupyterhub/jupyterhub:1.2@sha256:39de8fd25e6540e120fc13d69531633dc5852e178ecf1a848dac23cd5b6e6f3b

RUN apt update && apt install -y iproute2 curl git
RUN pip install git+https://github.com/jupyterhub/dockerspawner.git


# COPY cull_idle_servers.py /srv/jupyterhub/
# COPY jupyterhub_config.py /srv/jupyterhub/
