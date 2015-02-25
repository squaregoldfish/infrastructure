FROM debian:wheezy

COPY alfrescostop.sh /etc/init.d/alfrescostop.sh

COPY alfrescostart.sh /usr/local/bin/alfrescostart.sh

RUN ln -s /etc/init.d/alfrescostop.sh /etc/rc0.d/K01alfrescostop.sh \ 
	&& groupadd postgres && useradd -g postgres postgres \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update && apt-get install -y locales \
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo "sv_SE.UTF-8 UTF-8" >> /etc/locale.gen \
	&& echo 'LANG="sv_SE.UTF-8"' > /etc/default/locale \
	&& locale-gen

	
