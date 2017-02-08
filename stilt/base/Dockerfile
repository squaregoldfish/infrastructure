FROM rocker/r-base

RUN apt-get update -y \
&& apt-get upgrade -y \
&& apt-get install -y build-essential \
&& apt-get install -y csh \

#==== Install fields package in R - Also download and install packages maps and spam due to dependencies ===========
#Check this page if links to packages change https://cran.r-project.org/web/packages/available_packages_by_name.html
#Check this page if links to CRAN mirrors, download sites, https://cran.r-project.org/

&& wget https://static.icos-cp.eu/share/docker/stilt/maps_3.1.1.tar.gz \
&& gunzip maps_3.1.1.tar.gz \
&& R CMD INSTALL maps_3.1.1.tar maps \

&& wget https://static.icos-cp.eu/share/docker/stilt/spam_1.4-0.tar.gz \
&& gunzip spam_1.4-0.tar.gz  \
&& R CMD INSTALL spam_1.4-0.tar spam \

&& wget https://static.icos-cp.eu/share/docker/stilt/fields_8.10.tar.gz \
&& gunzip fields_8.10.tar.gz \
&& R CMD INSTALL fields_8.10.tar fields \

#========Install package sp for R==========================================================
&& wget https://static.icos-cp.eu/share/docker/stilt/sp_1.2-4.tar.gz \
&& gunzip sp_1.2-4.tar.gz \
&& R CMD INSTALL sp_1.2-4.tar sp \

#========Install fortran library for netcdf================================================
&& apt-get update -y \
&& apt-get install -y libnetcdff6 \

#========Install HDF-5=====================================================================
&& cd /opt/ \

&& wget https://static.icos-cp.eu/share/docker/stilt/hdf5-1.8.15-patch1.tar \

&& tar -xvf hdf5-1.8.15-patch1.tar \
&& rm hdf5-1.8.15-patch1.tar \
&& cd hdf5-1.8.15-patch1 \
&& ./configure --prefix=/opt/hdf5 \
&& make \
&& make check \
&& make install \
&& make check-install \

#========Install netCDF FOR C and FORTRAN=================================================
&& apt-get install -y libnetcdf-dev \
&& apt-get install -y libnetcdff-dev \

&& cd /usr/lib \
&& ln -s x86_64-linux-gnu/libnetcdf.so libnetcdf.so \
&& ln -s x86_64-linux-gnu/libnetcdff.so libnetcdff.so \
#&& ln -s x86_64-linux-gnu/libnetcdf.so.11.0.0 libnetcdf.so \
#&& ln -s x86_64-linux-gnu/libnetcdff.so.6.1.1 libnetcdff.so \
#&& ln -s libnetcdf.so.7.1.1 libnetcdf.so \
#&& ln -s libnetcdff.so.5.1.0 libnetcdff.so \

#========Install package ncdf for R=======================================================
&& wget https://static.icos-cp.eu/share/docker/stilt/ncdf4_1.15.tar.gz \
&& gunzip ncdf4_1.15.tar.gz \
&& tar -xvf ncdf4_1.15.tar \
&& R CMD INSTALL ncdf4_1.15.tar ncdf


#=======GET the STIL-project and compile it with Fortran=============================
ARG JENASVNUSER
ARG JENASVNPASSWORD

COPY ./setup.sh /opt/

RUN cd /opt \
&& mkdir STILT_svn \
&& mkdir STILT_modelling \
&& mkdir STILT_modelling/Input \

#subversion depends on this
&& apt-get install -y libsvn1 \
&& apt-get install -y subversion \
&& cd /opt/STILT_svn \
&& svn --username $JENASVNUSER --password $JENASVNPASSWORD --non-interactive  checkout https://projects.bgc-jena.mpg.de/STILT/svn/trunk \
&& cp -R /opt/STILT_svn/trunk/stiltR /opt/STILT_modelling/ \

&& cp /opt/setup.sh /opt/STILT_modelling \
&& chmod +x /opt/STILT_modelling/setup.sh \
&& /opt/STILT_modelling/setup.sh \
&& rm /opt/STILT_modelling/setup.sh \
&& rm /opt/setup.sh

COPY ./Makefile /opt/STILT_svn/trunk/merged_stilt_hysplit/

RUN cd /opt/STILT_svn/trunk/merged_stilt_hysplit \
&& make \
&& mv /opt/STILT_svn/trunk/merged_stilt_hysplit/hymodelc /opt/STILT_modelling/ \
&& rm /opt/STILT_modelling/stiltR/shlib/build.sh

COPY ./build.sh /opt/STILT_modelling/stiltR/shlib/

RUN cd /opt/STILT_modelling/stiltR/shlib/ \
&& chmod u+x build.sh \

#Solves an issue with docker in MACs
&& sleep 1 \
&& ./build.sh

ENV JENASVNUSER="" JENASVNPASSWORD="" 
