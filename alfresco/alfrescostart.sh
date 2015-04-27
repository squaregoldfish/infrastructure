#!/bin/bash

chown -R postgres:postgres /opt/alfresco-"$ALFRESCO_VERSION"/alf_data/postgresql

chown -R postgres:root /opt/alfresco-"$ALFRESCO_VERSION"/postgresql

trap "/opt/alfresco-$ALFRESCO_VERSION/alfresco.sh stop" TERM

/opt/alfresco-"$ALFRESCO_VERSION"/alfresco.sh start

if [ "$?" -eq 0 ]
then
	PGPID=`cat /opt/alfresco-"$ALFRESCO_VERSION"/alf_data/postgresql/postmaster.pid | head -n 1`
	while [[ `pidof postgres` ]]; do sleep 1; done
fi

