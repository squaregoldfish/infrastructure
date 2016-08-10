FROM jupyter/datascience-notebook:latest

MAINTAINER ingrid.vanderlaan@wur.nl

USER root

RUN apt-get update && apt-get install -y libhdf4-dev
RUN conda install -y -c anaconda -n python2 netcdf4=1.1.1
RUN conda install -y -c anaconda -n python2 matplotlib=1.5.1
RUN conda install -y -c jacksongs -n python2 mpld3=0.2
RUN conda install -y -c ncar -c khallock -n python2 pynio pyngl

USER $NB_USER

