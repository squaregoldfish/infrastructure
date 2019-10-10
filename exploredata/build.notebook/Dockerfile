FROM jupyterhub/jupyterhub:1.0

RUN conda install -y -c pyviz pyviz

RUN conda install -y anaconda ipywidgets xlrd

RUN conda install -y --override-channels -c main -c conda-forge cdo python-cdo mpld3 geopandas pscript netcdf4 netcdf-fortran tqdm ipyleaflet basemap-data-hires jupyterlab

RUN conda install -y geoviews

RUN apt update -y && apt install -y iproute2 iputils-ping

RUN conda install -y -c conda-forge folium

RUN useradd --create-home jovyan

# These were taken from the jupyter/base-notebook image
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/

WORKDIR /home/jovyan

ADD education ./education
ADD icos_jupyter_notebooks ./icos_jupyter_notebooks

RUN chown -R jovyan: /home/jovyan

# CMD ["jupyterhub-singleuser", "--debug", "--ip=0.0.0.0"]
CMD ["start-notebook.sh"]
USER jovyan

COPY execute-in-environment.sh /
ENTRYPOINT ["/execute-in-environment.sh"]
