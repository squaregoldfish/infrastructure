mongodump:
	docker-compose exec restheart_mongo mongodump --quiet --gzip --archive server.archive

mongorestore:
	echo "docker-compose exec restheart_mongo mongorestore --gzip --archive --drop < server.archive"
