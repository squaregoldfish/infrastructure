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

