# This Makefile serves as a place to keep commands that are useful when
# maintaining the geoip app. To try it, use 'make status'.

# Show the status of the docker containers
status:
	docker-compose ps

# Open the database cache for inspection
sqlite:
	sqlite3 volumes/db/ip.sqlite

# Start a shell in the running container
shell:
	docker-compose exec geoip bash

# Watch the database cache and the http logs simultaneous.
watch:
	watch -t "bash -c \"echo -e '-- Last inserts into database --\n'; sqlite3 volumes/db/ip.sqlite 'select * from ips order by id desc limit 10'; echo -e '\n\n-- Last http logs--\n'; tail -10 /var/log/nginx/geoip.log\""

# One of the ways this might break is if config.py has changed in the repo, then
# it won't get updated and we'll continue using the old version.
yolo-upgrade:
	(cd build/repo && git pull)
	docker-compose down
	docker-compose up --build -d
