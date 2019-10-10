FROM jupyterhub/jupyterhub:1.0

RUN pip install dockerspawner
RUN apt update && apt install -y iproute2 curl

COPY cull_idle_servers.py /srv/jupyterhub/
COPY jupyterhub_config.py /srv/jupyterhub/
