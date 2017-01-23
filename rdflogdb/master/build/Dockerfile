FROM postgres:9.6

COPY pg_hba.conf /tmp
COPY postgresql.conf /tmp
COPY setup.sh /docker-entrypoint-initdb.d/asetup.sh
RUN chmod 700 /docker-entrypoint-initdb.d/asetup.sh
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh