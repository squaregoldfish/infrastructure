FROM ce9d61cb8e6d87dff5fa7226967fe3445897cf9827bd3a4d2232df3b48bf778e

#===========SET UP TEST CASE==============================================================

COPY ./changes/* /opt/STILT_modelling/
COPY ./changes/stiltR/* /opt/STILT_modelling/stiltR/
COPY ./changes/stiltR/shlib/* /opt/STILT_modelling/stiltR/shlib/
RUN cd /opt/STILT_modelling/stiltR/shlib/ \
&& ./build.sh