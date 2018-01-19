FROM jupyterhub/jupyterhub

LABEL maintainer="mitch.selander@gis.lu.se"

RUN apt-get update \
	&& apt-get install -y lsb-core 

RUN conda install -y notebook \
	&& conda create -n py2 python=2.7 anaconda 

RUN /opt/conda/envs/py2/bin/python2 -m ipykernel install

ENV PATH=/opt/conda/envs/py2/bin:$PATH \
    PYTHONPATH=/opt/pyscrip/PySCRIP-master/

RUN conda install -c anaconda -y --name py2 basemap=1.0.7

# pandas and bottleneck are used by xarray, which in turn is used by cdo, both in the conda-forge channel
RUN conda install pandas bottleneck

#pyngl 
RUN conda install -y -c conda-forge --name py2 mpld3 netcdf4 netcdf-fortran python-cdo cdo pynio sparqlwrapper xarray basemap-data-hires tqdm \
	&& conda install -y ipywidgets

RUN ln -s /opt/conda/envs/py2/bin/cdo /usr/local/bin

WORKDIR /opt/

RUN curl https://static.icos-cp.eu/share/docker/pyscrip.tar.gz | tar xvz

COPY Makefile /opt/pyscrip/PySCRIP-master/PySCRIP/

WORKDIR /opt/pyscrip/PySCRIP-master/PySCRIP/

RUN apt-get install -y gfortran \
    && apt update && apt upgrade -y \
	&& make

RUN apt-get install -y libblas-dev liblapack-dev libfftw3-dev tcsh \
	&& pip install --upgrade pip \
	&& pip install pyshtools \  
	&& pip install shapely[vectorized]==1.6b2 
