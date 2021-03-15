# https://hub.docker.com/r/jupyterhub/jupyterhub/tags
FROM jupyterhub/jupyterhub:1.3

RUN pip install dockerspawner jupyterhub-idle-culler
RUN apt update && apt install -y iproute2 curl
