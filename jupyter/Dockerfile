FROM jupyterhub/jupyterhub

MAINTAINER mitch.selander@gis.lu.se

#Use bash instead of sh to allow for the use of source to activate the conda environments
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh

RUN apt-get update \
	&& apt-get install -y lsb-core 

RUN conda install notebook \
	&& conda create -n py2 python=2.7 anaconda 

WORKDIR /opt/conda/envs/py2/lib/python2.7/site-packages/

RUN python ipykernel install

RUN source activate py2 \ 
	&& python ipykernel install 

ENV PATH=/opt/conda/envs/py2/bin:$PATH \
    PYTHONPATH=/opt/pyscrip/PySCRIP-master/

RUN conda config --add channels conda-forge \
	&& conda install --name py2 netcdf4 netcdf-fortran 

RUN conda config --add channels ncar \
	&& conda config --add channels khallock \
	&& conda install --name py2 mpld3=0.2 pynio pyngl basemap=1.0.7

WORKDIR /opt/

RUN curl https://static.icos-cp.eu/share/docker/pyscrip.tar.gz | tar xvz

COPY Makefile /opt/pyscrip/PySCRIP-master/PySCRIP/

WORKDIR /opt/pyscrip/PySCRIP-master/PySCRIP/

RUN make

RUN apt-get install -y libblas-dev liblapack-dev libfftw3-dev tcsh \
	&& pip install pyshtools


