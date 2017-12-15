FROM rocker/r-base

RUN apt-get update -y && apt-get install -y subversion

# Install HDF-5.
# Start of with this package since it's compilation is very time consuming and
# having this layer cached makeis it easier to experiment with the rest of this
# file.
WORKDIR /opt/build
RUN wget https://static.icos-cp.eu/share/docker/stilt/hdf5-1.8.15-patch1.tar -O - | tar xf -

WORKDIR hdf5-1.8.15-patch1
RUN ./configure --prefix=/opt/hdf5
# This will spew out hundreds of pages of C compiler warnings, silence those
RUN make > /dev/null 2>&1
RUN make check install check-install


# Install R packages
# Check this page if links to packages change:
#   https://cran.r-project.org/web/packages/available_packages_by_name.html
WORKDIR /opt/build

RUN wget https://static.icos-cp.eu/share/docker/stilt/maps_3.1.1.tar.gz
RUN R CMD INSTALL maps_3.1.1.tar.gz

RUN wget https://static.icos-cp.eu/share/docker/stilt/spam_1.4-0.tar.gz
RUN R CMD INSTALL spam_1.4-0.tar.gz

RUN wget https://static.icos-cp.eu/share/docker/stilt/fields_8.10.tar.gz
RUN R CMD INSTALL fields_8.10.tar.gz

RUN wget https://static.icos-cp.eu/share/docker/stilt/sp_1.2-4.tar.gz
RUN R CMD INSTALL sp_1.2-4.tar.gz


# Install NetCDF
RUN apt-get install -y libnetcdf-dev libnetcdff-dev
# Use bash in order to get brace expansion
RUN ["/bin/bash", "-c", "ln -s /usr/lib/x86_64-linux-gnu/libnetcd{f,ff}.so /usr/lib/"]
RUN wget https://static.icos-cp.eu/share/docker/stilt/ncdf4_1.15.tar.gz
RUN R CMD INSTALL ncdf4_1.15.tar.gz


# Check out the STILT project and compile it.
ARG JENASVNUSER
ARG JENASVNPASSWORD

WORKDIR /opt/STILT_svn
RUN svn --username $JENASVNUSER --password $JENASVNPASSWORD --non-interactive checkout https://projects.bgc-jena.mpg.de/STILT/svn/trunk

WORKDIR /opt/STILT_modelling/
RUN cp -r /opt/STILT_svn/trunk/stiltR .
COPY setup.sh .
RUN chmod +x setup.sh && ./setup.sh && rm setup.sh

WORKDIR /opt/STILT_svn/trunk/merged_stilt_hysplit
COPY Makefile .
RUN make
RUN mv hymodelc /opt/STILT_modelling/

WORKDIR /opt/STILT_modelling/stiltR/shlib
COPY build.sh .
# The sleep is to solve an issue with docker on MACs
RUN sleep 1 && chmod +x build.sh && ./build.sh
