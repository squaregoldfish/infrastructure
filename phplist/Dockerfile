# Based on image from https://hub.docker.com/_/php/

from php:5.6-apache

run a2enmod rewrite

run apt-get update && apt-get install -y \
	vim \
	&& docker-php-ext-install pdo pdo_mysql mysql mysqli
	
run { \
		echo 'upload_max_filesize=1M'; \
		echo 'post_max_size=10M'; \
		echo 'date.timezone=UTC'; \
	} > /usr/local/etc/php/conf.d/php-conf.ini

workdir /var/www/html
