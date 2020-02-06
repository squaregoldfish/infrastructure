FROM jupyterhub/jupyterhub:1.2@sha256:b0681c4eb79f45b28afebdba23b8b4f5784ef0cfc44d03396fb435f586ca5bcc

RUN pip install dockerspawner
RUN apt update && apt install -y iproute2 curl

# COPY cull_idle_servers.py /srv/jupyterhub/
# COPY jupyterhub_config.py /srv/jupyterhub/
