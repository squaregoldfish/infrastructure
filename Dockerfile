FROM debian:wheezy

RUN groupadd postgres && useradd -g postgres postgres \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get install -y \
	locales \
	procps \
	libcups2 \
	libdbus-glib-1-2 \
	libfontconfig1 \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "sv_SE.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo 'LANG="sv_SE.UTF-8"' > /etc/default/locale \
	&& locale-gen

COPY alfrescostart.sh /usr/local/bin/

