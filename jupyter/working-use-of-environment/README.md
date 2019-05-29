# Overview

This directory serves as a starting point in building dependable and repeatable
Docker images containing anaconda environments.

To try it out:

	# This will create three different docker images, take about 10 minutes and
	# download half the internet.
	$ make


# The problem - using conda with the 'base' environment.

For conda to work properly, it needs to have an activated environment. By
default conda has an environment called "base", but it's not activated. This
can be seen by running


	$ conda info --envs
	# conda environments:
	#
	base                  *  /opt/conda$ conda
	$ conda info | grep active
		active environment : None

This means that you can still install packages, but they won't always work.

	$ conda config --env --append channels conda-forge
	$ conda install basemap-data-hires
	$ python
	Python 3.6.7 | packaged by conda-forge | (default, Feb 28 2019, 09:07:38)
	[GCC 7.3.0] on linux
	Type "help", "copyright", "credits" or "license" for more information.
	>>> from mpl_toolkits.basemap import Basemap
	from mpl_toolkits.basemap import Basemap
	Traceback (most recent call last):
	  File "<stdin>", line 1, in <module>
	  File "/opt/conda/lib/python3.6/site-packages/mpl_toolkits/basemap/__init__.py", line 155, in <module>
		pyproj_datadir = os.environ['PROJ_LIB']
	  File "/opt/conda/lib/python3.6/os.py", line 669, in __getitem__
		raise KeyError(key) from None
	KeyError: 'PROJ_LIB'


First the environment must be activated.

	$ source activate base
	$ python
	Python 3.6.7 | packaged by conda-forge | (default, Feb 28 2019, 09:07:38)
	[GCC 7.3.0] on linux
	Type "help", "copyright", "credits" or "license" for more information.
	>>> from mpl_toolkits.basemap import Basemap
	from mpl_toolkits.basemap import Basemap
	>>>


# Activating conda environments in Dockerfiles

Each "RUN" command in a Dockerfile is executed in a brand new shell. This means
that the environment variables set by "source activate myenv" don't persist
between "RUN"s.

One solution is to do everything in a single RUN.

	RUN source activate myenv && conda install foo && ...

The problem then becomes that:

1. The more packages one adds to 'conda install', the longer condas dependency
   resolver takes; and it's already very slow.
2. Sometimes the dependency resolver gives up or crashes.
3. If you add packages you will break the 'docker build' caching.

The solution used here is to use the "SHELL" command to have everything run in
an activated environment.

	SHELL ["conda", "run", "--name", "base", "bash", "-c"]

This will make all subsequent "RUN"s have the proper environment
activated. Finally the ENTRYPOINT is also modified to activate the environment.


# Further work

To create a dependable and repeatable Docker/Anaconda build, further work is
needed.

+ Specifying an exact version of the starting jupyterhub image.
+ Freezing the conda environment.
+ Periodically updating and re-freezing the environment.

For bonus points, no actual development should be done in jupyter, only
presentations.


## Specifying an exact version of the starting jupyterhub image

Starting a Dockerfile with the current line

	FROM jupyterhub/jupyterhub

Means that you get _a_ version of jupyterhub. More specifically you get the
version tagged "latest". Furthermore, if you've requested this image anytime in
the past you'll already have "jupyterhub/jupyterhub:latest" on your machine -
and that version will be used. Even if it's two years old. Yes.

Using the following instead is slightly better.

	FROM jupyterhub/jupyterhub:1.0

It will always - hopefully! - get you a version of the 1.0 branch, even though
it might be 1.0.1 or 1.0.97.

Even better is finding the exact hash of the base image.

	$ docker inspect jupyterhub/jupyterhub:1.0 -f '{{ .RepoDigests }}'
	[jupyterhub/jupyterhub@sha256:2bd3ea9602f61aa719a4f9458c64966c9cd839145cec08f0f1980124595dbd69]

And then specifying the exact hash sum in the Dockerfile.

	FROM jupyterhub/jupyterhub@sha256:2bd3ea9602f61aa719a4f9458c64966c9cd839145cec08f0f1980124595dbd69


## Freezing the conda environment.

The exact package versions installed using conda can be dumped.

	# conda list --export
	# This file may be used to create an environment using:
	# $ conda create --name <env> --file <this file>
	# platform: linux-64
	alembic=1.0.10=pypi_0
	asn1crypto=0.24.0=py36_1003
	async-generator=1.10=pypi_0
	ca-certificates=2019.3.9=hecc5488_0
	...

An exact replica can then be recreated using

	conda create --name default --file environment.yml


## Periodically updating and re-freezing the environment.

Every now and then, the image should be updated to the latest version of
jupyterhub and all required packages should be updated to their latest
version. The resulting image should then be tested and ones code should be
updated. Then the environment should then be re-frozen.
