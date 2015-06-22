Docker files for various ICOS Carbon Portal services
====================================================

alfresco
--------
Alfresco document management system, deployed at https://docs.icos-cp.eu

thredds
-------
Unidata's THREDDS Data Server, deployed at http://thredds.icos-cp.eu

drupal
------
ICOS Drupal installation, deployed at https://www.icos-ri.eu/  
Was developed for ICOS by Aleksi Johansson from [Wunderkraut](http://wunderkraut.com/)


Getting started
===============
To get started, one needs:  
- Linux
- Git
- Docker
- docker-compose

To avoid cloning the whole `infrastructure` repository, one can use Git's sparse checkouts.
To automate sparse cloning you can use the `sparse.sh` script from the root of this repo.
Run the following from a newly created folder for your new repo:

`wget https://github.com/ICOS-Carbon-Portal/infrastructure/raw/master/sparse.sh`  
`./sparse.sh <subproject> [<branch>]` (default branch is `master`)

`subproject` above must be one of the first-level folders in this repo.


