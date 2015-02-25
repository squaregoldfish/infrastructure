#!/bin/bash

chown -R postgres:postgres /opt/alfresco-"$ALFRESCO_VERSION"/alf_data/postgresql

chown -R postgres:root /opt/alfresco-"$ALFRESCO_VERSION"/postgresql

trap alfrescostop.sh SIGTERM

/opt/alfresco-"$ALFRESCO_VERSION"/alfresco.sh start

/bin/bash
