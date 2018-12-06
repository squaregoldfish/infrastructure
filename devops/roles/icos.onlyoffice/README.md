# Overview

This role will the OnlyOffice Documentserver as a docker container proxied by a
host nginx.

# Purpose

It's was meant for integration with Nextcloud. That's also how it was tested. It
doesn't really need any storage of its own.

# Assumptions

* That docker is installed.
* That nginx is installed.

# Known bugs

* It's very complex. The single container will use supervised(1) to start:
  * postgres 9.5 (i.e, an older version)
  * redis
  * nginx (for internal proxying)
  * cron
  * rabbitmq (a message-queue in erlang)
  * a bunch of node.js services
* It doesn't support running as a different user
  * It'll start some services as other users and some as root

# Resources
https://hub.docker.com/r/onlyoffice/documentserver/
https://api.onlyoffice.com/editors/nextcloud
https://docs.nextcloud.com/server/14/admin_manual/contents.html
https://help.nextcloud.com/
https://github.com/ONLYOFFICE/Docker-DocumentServer/blob/master/README.md#running-onlyoffice-document-server-using-https
https://helpcenter.onlyoffice.com/server/docker/document/docker-installation.aspx
