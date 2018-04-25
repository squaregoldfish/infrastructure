# Docker compose based on RESTHeart

Intended to be used for storing usage statistics of Carbon Portal services and some service- and user-specific information.

## How to:

* Rename example.docker-compose.yml to docker-compose.yml

* In docker-compose.yml
  * Specify appropriate port numbers for the host. Keep the localhost IP if it should be accessible just from localhost.
  * Specify an appropriate folder path on the host for the MongoDB's persistent data.

* In security.yml
  * In the default configuration the unauthenticated user allows to act as a admin. Remind to handle the authentication outside the RESTHeart area or specify appropriated settings.

* Fetch the images, create and start the RESTHeart and MongoDB containers
  * `docker-compose up -d`


## Useful commands

Specify aggregations for a collection:

`curl -H "Content-Type: application/json" --upload-file dobjAggrs.json http://127.0.0.1:8088/db/dobjdls`

Users that specified ORCID ID in their user profile:

`curl -G --data-urlencode 'keys={"_id":1, "profile.orcid":1}' --data-urlencode 'filter={"profile.orcid":{"$regex": ".+"}}' http://127.0.0.1:8088/db/users?count=true`

Get download counts per IP address:

`curl -o page1.json 'https://restheart.icos-cp.eu/db/dobjdls/_aggrs/perIp?pagesize=1000&page=1'`

Transform download counts json from the previous command to tsv (requires jq installed):

`cat page1.json | jq -r '._embedded[] | [.count, .ip, .megabytes] | @tsv' > page1.tsv`

Sort the results by download count descending:

`cat page1.tsv page2.tsv | sort -nr > icos_dl_stats_2018-03-27.tsv`

