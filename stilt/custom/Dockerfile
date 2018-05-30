FROM stiltbase

COPY ./changes/* /opt/STILT_modelling/
COPY ./changes/stiltR/* /opt/STILT_modelling/stiltR/
COPY ./changes/stiltR/shlib/* /opt/STILT_modelling/stiltR/shlib/

WORKDIR /opt/STILT_modelling/stiltR/shlib/
RUN ./build.sh
WORKDIR /opt/STILT_modelling
