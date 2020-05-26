# Overview

+ Installs PostgresQL and optionally PostGIS.
+ Installs the psycopg2 python library (required by ansible).
+ Ubuntu only.
+ Uses the PostgresQL package archives.

# Options

## superuser password
By default the `postgres` user (the database superuser) doesn't have a password
set and the only way to login in is through a unix socket. Setting
`postgresql_postgres_password` sets a password:

    - role: icos.postgresql
      postgresql_postgres_password: "{{ vault_postgres_password }}"
    

## listen addresses

To connect to postgresql from another host, set `postgresql_listen_addresses`,
not the double quoting. This will restart the postgres server to take effect,
so watch out in production

    - role: icos.postgresql
      postgresql_listen_addresses: "'*'"


## install postgis

The official postgresql package repos packages PostGIS as well, set
`postgresql_postgis_enable` to install it.

    - role: icos.postgresql
      postgresql_postgis_enable: true
