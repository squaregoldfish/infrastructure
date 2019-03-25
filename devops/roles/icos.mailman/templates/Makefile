ps:
	docker-compose ps

psql:
	docker-compose exec database psql -U mailman mailmandb

coreconf:
	docker-compose exec mailman-core mailman conf

restapi:
	@echo https://mailman.readthedocs.io/en/latest/src/mailman/rest/docs/rest.html
	@echo "http://{{ mailman_core_ipv4 }}:{{ mailman_rest_port }}/rest/3.1/system/versions"

weblog:
	bash -c 'tail -f volumes/web/logs/{mailmanweb,uwsgi}.log /var/log/nginx/{mailman,error}.log'

maillog:
	bash -c 'tail -f /var/log/mail.log volumes/core/var/logs/*'

fail2ban:
	fail2ban-client status; fail2ban-client status postfix-auth

coldbackup:
	./coldbackup.sh makefile

listbackup:
	bin/bbclient list --short

cronbackup:
	./coldbackup.sh cron
