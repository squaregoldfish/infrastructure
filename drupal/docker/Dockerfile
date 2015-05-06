# Docker image specification for ICOS
#
# VERSION 0.0.1

FROM centos:6.6
MAINTAINER Aleksi Johansson <aleksi.johansson@wunderkraut.com>

# Install the required software
COPY build.sh /tmp/build.sh
COPY nginx/nginx.repo /etc/yum.repos.d/nginx.repo
COPY mariadb/MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN /bin/bash /tmp/build.sh
RUN rm /tmp/build.sh

# Set the environments
ENV PATH /root/.composer/vendor/bin:$PATH
ENV DRUSH_PHP /usr/bin/php
ENV WKV_SITE_ENV docker

# Copy the the Nginx + PHP + Memcached + Varnish Cache stack configuration
COPY php/www.conf /etc/php-fpm.d/
COPY php/php.ini /etc/
COPY php/php-fpm.conf /etc/
COPY varnish/varnish /etc/sysconfig/
COPY varnish/default.vcl /etc/varnish/
COPY nginx/nginx.conf /etc/nginx/
COPY nginx/mime.types /etc/nginx/
COPY nginx/conf.d/* /etc/nginx/conf.d/
RUN mkdir /etc/nginx/sites-enabled
COPY nginx/sites-enabled/* /etc/nginx/sites-enabled/

# Expose the Nginx, Varnish and Varnish backend ports
EXPOSE 8080
EXPOSE 80
EXPOSE 6082

# Start the services
CMD ["/bin/bash", "/entrypoint/entrypoint.sh"]