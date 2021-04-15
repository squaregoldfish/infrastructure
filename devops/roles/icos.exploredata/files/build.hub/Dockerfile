# https://hub.docker.com/r/jupyterhub/jupyterhub/tags
FROM jupyterhub/jupyterhub:1.3

ENV DEBIAN_FRONTEND=noninteractive

RUN pip install dockerspawner jupyterhub-idle-culler
RUN apt update && apt install -y iproute2 curl tzdata

RUN ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
