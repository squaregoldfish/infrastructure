#!/bin/bash

set -u

chown -R postgres:postgres /opt/alfresco-"$ALFRESCO_VERSION"/alf_data/postgresql

chown -R postgres:root /opt/alfresco-"$ALFRESCO_VERSION"/postgresql

trap "/opt/alfresco-$ALFRESCO_VERSION/alfresco.sh stop" TERM

/opt/alfresco-"$ALFRESCO_VERSION"/alfresco.sh start

if [ "$?" -eq 0 ]
then
	while [[ `pidof postgres` ]]; do sleep 1; done
fi

