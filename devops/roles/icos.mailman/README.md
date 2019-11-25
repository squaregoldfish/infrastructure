# Overview

This role will install [GNU Mailman](https://www.gnu.org/software/mailman/)

It installs Mailman using three separate Docker images, as described by the
[official mailman
documentation](http://docs.mailman3.org/en/latest/prodsetup.html#mailman-3-in-docker).

Dependencies:
* Postfix is required on the host. Use the icos.postfix role.

Installation proceeds as follows:

* The host nginx is setup with Let's Encrypt certificates and then
  configured as a reverse-proxy for the postorious and hyperkitty web
  GUIs.
* A special host user ("mailman") is created. All three mailman
  containers will run as this user and the user will own all data in
  the volume directories.
* Everything required to build the images is copied to the host and
  all three images are built.
* The mailman service is started through docker-compose.


## Building the docker images

All three images are built on the host as part of deployment. During
the docker build, all three images have their default user's UID
modified to match the host mailman user.


### The 'database' container

* Vanilla postgresql-10.


### The 'core' container

* Runs the actual mailman backend software.
* Sends mail through the host postfix.
* The host postfix then receives mail from the internet and relays it
  to the core container.
* This is done through files written in core's volume -
  /docker/mailman/volumes/core/vara/data/postfix_*


### The 'web' container

* Runs two Django web frontends - postorius and hyperkitty.
* These are run by the container using uwsgi.
* The host nginx will then reverse proxy traffic to it.
* Since they are django applications, much of the configuration is
  done using the manage.py command.


## Startup

+ The entrypoint is /usr/local/bin/docker-entrypoint.sh
+ Will wait for database to become available.
+ Copies settings_local.py from /opt/mailman-web-data to/ opt/mailman/web
+ Start uwsgi which will start hyperkitty using django
+ django reads settings.py and settings_local.py


## Administrative tasks

### Removing a hyperkitty archive

https://gitlab.com/mailman/hyperkitty/issues/146

    $ docker-compose exec mailman-web /opt/mailman-web/manage.py shell
    >>> from hyperkitty.models import MailingList
    >>> ml = MailingList.objects.get(name='list@domain')
    >>> ml.delete()


## Resources for configuring postfix
http://www.postfix.org/INSTALL.html#mandatory
https://github.com/maxking/docker-mailman#setting-up-your-mta
