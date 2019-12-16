FROM jupyterhub/jupyterhub

LABEL maintainer="mitch.selander@gis.lu.se"

COPY jupyterhub_config.py /srv/jupyterhub/

RUN apt-get update \
	&& apt-get install -y lsb-core 

RUN conda update -y -c defaults conda

RUN conda install -y -c pyviz pyviz

RUN conda install -y anaconda ipywidgets xlrd

RUN conda install -y --override-channels -c main -c conda-forge cdo python-cdo mpld3 geopandas pscript netcdf4 netcdf-fortran tqdm ipyleaflet basemap-data-hires jupyterlab

RUN conda install -y geoviews
