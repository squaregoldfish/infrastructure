ICOS Drupal
===========
Oridinally developed by Aleksi Johansson from [Wunderkraut](http://wunderkraut.com/), maintained by the [Carbon Portal](https://www.icos-cp.eu/) team.

Deploying a website instance
----------------------------
- Clone this repository. Sparse cloning can be used as described in the top-level README.md.
- Make a copy of `drupal/docker/example.docker-compose.yml` named `docker-compose.yml` in the same folder, then edit it as needed.
- Create a file `name-prefix.txt` in `drupal/docker`, put a single short string that will distinguish this website instance.
- Make a copy of `drupal/drupal/example.docker.settings.php` named `docker.settings.php` in the same folder, then edit it as needed. Make sure database config and credentials match those of `docker-compose.yml` mentioned above.
- Navigate to the top-level `drupal` folder
- Run `./docker.sh up`.

Eventually, this will start three new docker containers whose names begin with the prefix specified in `name-prefix.txt` file: one with MariaDB database, one with memcache, and one with Drupal/Nginx installation which is linked to the other two. The latter will perform Drupal installation and configuration first. You can follow the progress by looking at the container's log: `docker logs <container-name>` (run as root; container name is most likely `<prefix>_drupal_1`, you can check it with `docker ps`).
