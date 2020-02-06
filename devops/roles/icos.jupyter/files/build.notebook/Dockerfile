# https://hub.docker.com/r/jupyter/base-notebook/dockerfile
# jupyter/base-notebook:python-3.7.4
FROM jupyter/base-notebook@sha256:a4b03739ac37a0ccc38d71779c236f82cae342936be81d5c9d677497a8a84dfe

# Switch from jovyan back to root in order to get global installs
USER root

# Stop conda nagging everytime it's invoked.
RUN conda config --set notify_outdated_conda False

# PYTHON3
RUN conda install -y basemap-data-hires             && conda clean -afy
RUN conda install -y anaconda                       && conda clean -afy
RUN conda install -y bokeh cartopy                  && conda clean -afy
RUN conda install -y geoviews holoviews             && conda clean -afy
RUN conda install -y panel datashader hvplot param  && conda clean -afy
RUN conda install -y ipywidgets xlrd                && conda clean -afy
RUN conda install -y cdo python-cdo                 && conda clean -afy
RUN conda install -y geopandas mpld3 pscript        && conda clean -afy
RUN conda install -y netcdf4                        && conda clean -afy
RUN conda install -y tqdm ipyleaflet netcdf-fortran && conda clean -afy
RUN conda install -y folium                         && conda clean -afy

## PYTHON2
RUN conda create -n python2 python=2 ipykernel

RUN conda install -n python2 -y basemap-data-hires             && conda clean -afy
RUN conda install -n python2 -y anaconda                       && conda clean -afy
RUN conda install -n python2 -y bokeh cartopy                  && conda clean -afy
RUN conda install -n python2 -y geoviews holoviews             && conda clean -afy
RUN conda install -n python2 -y panel datashader hvplot param  && conda clean -afy
RUN conda install -n python2 -y ipywidgets xlrd                && conda clean -afy
RUN conda install -n python2 -y cdo python-cdo                 && conda clean -afy
RUN conda install -n python2 -y geopandas mpld3 pscript        && conda clean -afy
RUN conda install -n python2 -y netcdf4                        && conda clean -afy
RUN conda install -n python2 -y tqdm ipyleaflet netcdf-fortran && conda clean -afy
RUN conda install -n python2 -y folium                         && conda clean -afy

RUN conda run -n python2 python2 -mipykernel install

# PYTHON3
RUN conda install -y pytables hdf5                         && conda clean -afy
RUN conda install -y basemap bottleneck pandas             && conda clean -afy
RUN conda install -y pynio sparqlwrapper xarray            && conda clean -afy
RUN conda install -y shapely                               && conda clean -afy

# PYTHON2
RUN conda install -n python2 -y pytables hdf5              && conda clean -afy
RUN conda install -n python2 -y basemap bottleneck pandas  && conda clean -afy
RUN conda install -n python2 -y pynio sparqlwrapper xarray && conda clean -afy
RUN conda install -n python2 -y shapely                    && conda clean -afy

# BQPLOT
RUN conda install -y bqplot && conda install -n python2 -y bqplot && conda clean -afy

USER $NB_UID
