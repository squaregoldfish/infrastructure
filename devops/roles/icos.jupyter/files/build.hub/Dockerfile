# https://hub.docker.com/r/jupyterhub/jupyterhub/tags
# <2021-02-18> jupyterhub:1.3.0
FROM jupyterhub/jupyterhub:1.3@sha256:39de8fd25e6540e120fc13d69531633dc5852e178ecf1a848dac23cd5b6e6f3b

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && apt-get install -qy iproute2 curl git tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN pip install git+https://github.com/jupyterhub/dockerspawner.git


# COPY cull_idle_servers.py /srv/jupyterhub/
# COPY jupyterhub_config.py /srv/jupyterhub/
