# Docker compose based on RESTHeart


## How to:

* Rename example.docker-compose.yml to docker-compose.yml
    
* In docker-compose.yml
  * Specify appropriate port numbers for the host. Keep the localhost IP if it should be accessible just from localhost.
  * Specify an appropriate folder path on the host for the MongoDB's persistent data.
      
* In security.yml
  * In the default configuration the unauthenticated user allows to act as a admin. Remind to handle the authentication outside the RESTHeart area or specify appropriated settings.
    
* Install via docker-compose argument "up -d"
      
