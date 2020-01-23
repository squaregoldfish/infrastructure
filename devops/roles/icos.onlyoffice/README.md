# Overview

This role will install the OnlyOffice Documentserver as a docker container
proxied by a host nginx.

# Purpose

It's was meant for integration with Nextcloud. That's also how it was tested. It
doesn't really need any storage of its own.

# Assumptions

* That docker is installed.
* That nginx is installed.

# Known bugs

The below was true for 5.3.x, haven't looked into the new 5.4 version.

* The OnlyOffice image is very complex. The single container will use
  supervised(1) to start:
  * postgres 9.5 (i.e, an older version)
  * redis
  * nginx (for internal proxying)
  * cron
  * rabbitmq (a message-queue in erlang)
  * a bunch of node.js services
* It doesn't support running as a different user
  * It'll start some services as other users and some as root

# Resources
+ [Onlyoffice docker installation](https://github.com/ONLYOFFICE/Docker-DocumentServer/blob/master/README.md#running-onlyoffice-document-server-using-https)
+ [Community version (the one we're running)](https://helpcenter.onlyoffice.com/server/docker/community/index.aspx)
+ [The official forum](http://dev.onlyoffice.org/)
+ [Docker images and tags](https://hub.docker.com/r/onlyoffice/documentserver/)
+ [Nextcloud integration](https://api.onlyoffice.com/editors/nextcloud)
