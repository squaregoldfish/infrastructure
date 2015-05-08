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
	* Linux
	* Git
	* Docker
	* docker-compose

To avoid cloning the whole `infrastructure` repository, one can use Git's sparse checkouts.  
For example, to clone only `thredds` subproject, run the following:

`mkdir mythredds && cd mythredds`  
`git init`  
`git remote add -f origin git@github.com:ICOS-Carbon-Portal/infrastructure.git`  
`git config core.sparsecheckout true`  
`echo thredds/ >> .git/info/sparse-checkout`  
`git pull origin master`  

