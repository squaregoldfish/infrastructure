FROM postgres:10

RUN apt update
RUN apt install -y mg

RUN groupmod --gid={{ _user.group }} postgres
RUN usermod --uid={{ _user.uid }} --gid={{ _user.group }} postgres

WORKDIR /var/lib/postgresql/.postgresql
COPY peer.crt root.crt

WORKDIR /var/lib/postgresql
COPY pgpass .pgpass
RUN chmod 0600 .pgpass

RUN chown -R postgres: /var/lib/postgresql

ENV CONNINFO {{ pgrep_conninfo }}
ENV SLOTNAME {{ pgrep_peer_slot }}

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh

USER postgres
