# STILT modeling software

Standard Docker image build file and docker-compose config file for STILT langrangian transport model software.
Build process requires username and password for access to MPI-BCG's SVN repository (in Jena). Edit the docker-compose config accordingly.

## Importing the pre-build base STILT Docker image
Run as a member of `docker` group or as root:
`wget -O- https://static.icos-cp.eu/share/docker/stilt/image_cd65ca564e63.tgz | gunzip -c | docker import - local/stiltbase`


## Useful commands for running on Mac machine

### Preparing access to icos server

`mkdir -p Output/RData`

`mkdir -p Output/Results`

`mkdir -p Output/Footprints`

(readonly)

`sshfs  -o ro ute@icos-cp.eu:/disk/data/STILT/RData Output/RData`

(read+write)

`sshfs ute@icos-cp.eu:/disk/data/STILT/Results Output/Results`

`sshfs ute@icos-cp.eu:/disk/data/STILT/Footprints Output/Footprints`

`mkdir Input`

(readonly)

`sshfs  -o ro ute@icos-cp.eu:/disk/data/STILT Input`

### Building Docker image and starting a container

`docker build -t webstilt_nc_production .`

`docker run -d --name webstilt_nc_production -v $PWD/Input:/opt/STILT_modelling/Input/ -v $PWD/Output:/opt/STILT_modelling/Output/ -p 8080:9011 -t webstilt_nc_production`

`docker cp stiltweb-assembly-0.1.0.jar webstilt_nc_production:/opt`

###Starting a shell inside the container

`docker exec -it webstilt_nc_production /bin/bash`

Type this inside the container:

`java -jar /opt/stiltweb-assembly-0.1.0.jar`

Now open a web browser and go to this address:

`http://192.168.99.100:8080/`

On a mac this needs to be the address of the VM. Find this with: 

`docker-machine ip default`

