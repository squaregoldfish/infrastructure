ICOS Alfresco
===========

Deploying an Alfresco instance
----------------------------
- Install Alfresco to a certain folder using the graphic interactive installer. Use advanced setup. Include Java, PostgreSQL, Solr4, Google Docs Integration and LibreOffice in the installation. Use default ports and do not register Alfresco as a service. Do not start Alfresco after the install.
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Navigate to the `alfresco` directory.
- Make a copy of `example.docker-compose.yml` named `docker-compose.yml`, then edit it as needed.
- Create a file `name-prefix.txt` in the current directory, put in a single short string that will distinguish this Alfresco instance.
- Run `./docker.sh up`.

