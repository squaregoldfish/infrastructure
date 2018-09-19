FROM postgres:10

RUN apt update
RUN apt install -y mg

# Change gid/uid of postgres user to match system uid/gid
RUN groupmod --gid={{ _user.group }} postgres
RUN usermod --uid={{ _user.uid }} --gid={{ _user.group }} postgres

WORKDIR /docker-entrypoint-initdb.d
COPY init.sql .
COPY init.sh .
RUN chmod +x init.sh

USER postgres
