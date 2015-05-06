Administration
=====

## Administering the environment

### Drush

[Drush](http://www.drush.org/en/master/) is available on the environment to manage the Drupal instance via command line. Drush can be accessed from the root of the project via the drush.sh scrip.

For example you can clear the caches of the site by running:

<pre>./drush.sh cc all</pre>

### Docker

The project has a docker.sh script for easier management of the docker containers as a whole. The docker.sh script can be used for for example restarting the docker containers by running:

<pre>
./docker.sh stop
./docker.sh start
</pre>

#### Docker script (docker.sh) commands

<pre>./docker.sh up</pre>

Build and start the docker containers. This is automatically done when running on OS X:

<pre>vagrant up</pre>

so you don't need to run it manually.

<pre>./docker.sh rm</pre>

Remove the docker containers.

<pre>./docker.sh bash [environment]</pre>

Access the container with bash. [enviroment] can be either 'drupal' or 'mariadb'. These are the names of the containers specified in the docker-composer.yml.

<pre>./docker.sh build drupal [state]</pre>

Build new Drupal from the configuration files or update the current build. The [state] can be 'new', 'existing' or 'update'. Use 'update' to update the Drupal build after pulling new configuration from the repository. Use 'existing' to first purge previous build of Drupal before recreating it. This is similar to the 'update' state, but is needed on OS X setups because of NFS problems. Drupal is automatically built when the project is first started by running on Linux:
<pre>./docker.sh up</pre>
or on OS X:
<pre>vagrant up</pre>

so you don't need to build it manually.

<pre>./docker.sh </pre>

## Backup and restore

The site has [Backup and Migrate](https://www.drupal.org/project/backup_migrate) module installed and enabled. Administrators can use this tool to backup and restore the site via the Drupal UI from the administration menu Administration > Configuration > System > Backup and Migrate.