#!/bin/bash

# Setup the user for Nginx and PHP
useradd icos-admin -u 501 -s /bin/bash --no-create-home

# Install some needed utilities
yum install -y wget yum-utils git unzip tar

# Create required repositories
yum-config-manager --add-repo http://rpms.famillecollet.com/enterprise/remi.repo
rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/epel-release-6-5.noarch.rpm
rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/ius-release-1.0-13.ius.centos6.noarch.rpm
# Varnish from epel is too old (2.x)
rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm
yum update -y

# Install python-pip for build.sh
yum install -y python-pip

# Install the Varnish Cache + Nginx + PHP-FPM + MariaDB stack.
yum install -y php55u php55u-mysql php55u-mbstring php55u-pecl-memcache php55u-fpm php55u-devel php55u-gd php55u-pdo php55u-pecl-imagick php55u-xml php55u-mcrypt php55u-opcache php55u-pecl-jsonc gd gd-devel nginx varnish

# Install MariaDB client to be used with Drush
yum install -y MariaDB-client

# Package cleanup
yum clean all -y

# Install python yaml for Drupal building
pip install pyaml

# Install Composer and Drush. Add composer to PATH.
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require drush/drush:6.*
