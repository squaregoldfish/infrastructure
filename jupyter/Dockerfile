FROM jupyter/datascience-notebook:latest

MAINTAINER ingrid.vanderlaan@wur.nl

USER root

RUN apt-get update && apt-get install -y libhdf4-dev
RUN conda install -y -c anaconda -c jacksongs -c ncar -c khallock -n python2 netcdf4 matplotlib mpld3=0.2 pynio pyngl

USER $NB_USER

