FROM jupyter/datascience-notebook:latest

MAINTAINER ingrid.vanderlaan@wur.nl

USER root 

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/conda/bin \
    PYTHONPATH=/opt/pyscrip/PySCRIP-master/

RUN apt-get update \
&& apt-get install -y lsb-core 

RUN conda install -y -c anaconda -c jacksongs -c ncar -c khallock -n python2 netcdf4 matplotlib mpld3=0.2 pynio pyngl

RUN conda install -y -c anaconda -n python2 basemap=1.0.7 

RUN conda install -y -c ioos -n python2 netcdf-fortran=4.4.2 \
&& conda clean -tipsy

ENV PATH /opt/conda/envs/python2/bin:$PATH

RUN cd /opt/ \
&& curl https://static.icos-cp.eu/share/docker/pyscrip.tar.gz | tar xvz

COPY Makefile /opt/pyscrip/PySCRIP-master/PySCRIP/

RUN cd /opt/pyscrip/PySCRIP-master/PySCRIP/ \
&& make 

USER $NB_USER
