# Based on image from https://hub.docker.com/_/php/

from php:5.6-apache

run a2enmod rewrite

run apt-get update && apt-get install -y \
	vim libpng12-dev libjpeg-dev libpq-dev \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install pdo pdo_mysql mysql mysqli \
	&& docker-php-ext-install gd mbstring opcache pdo pdo_mysql pdo_pgsql zip \
	&& apt-get install -y php5-imap
	
run { \
		echo 'upload_max_filesize=100M'; \
		echo 'post_max_size=100M'; \
		echo 'date.timezone=UTC'; \
		echo 'extension=imap.so'; \
	} > /usr/local/etc/php/conf.d/php-conf.ini


#run curl -sS https://getcomposer.org/installer | php \
#    && mv composer.phar /usr/local/bin/composer
    
workdir /var/www/html
