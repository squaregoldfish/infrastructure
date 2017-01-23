FROM postgres:9.6

COPY pg_hba.conf /tmp/pg_hba.conf
COPY postgresql.conf /tmp/postgresql.conf
COPY recovery.conf /tmp/recovery.conf
COPY setup.sh /docker-entrypoint-initdb.d/asetup.sh
