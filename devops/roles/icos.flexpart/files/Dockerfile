# First image installs fpc and compile the flextraset program
FROM ubuntu:18.04 as flextraset

RUN apt update -y
RUN apt install -y --no-install-recommends fpc

WORKDIR /compile/flextraset
COPY flextraset.lpr .

RUN fpc -Xt -XS -MObjFPC -Scghi -Cg -O1 -g -gl -Tlinux -l -vewnhibq -Filib/x86_64-linux -Fu. flextraset.lpr


# Second image installs gfortran and compiles flexpart
FROM ubuntu:18.04 as flexpart

RUN apt update -y
RUN apt install -y gfortran make file libnetcdff-dev libgrib-api-dev
RUN apt install -y curl

# A JPEG library needed by flexpart
RUN url=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz \
	&& mkdir -p /compile/ && curl -SL "$url" | tar -xzC /compile \
	&& cd /compile/jasper-1.900.29 && ./configure && make install

# Couldn't find a URL to this version, need to be available locally for now.
COPY flexpart10.2.tar.gz /compile/
RUN cd /compile && tar xzf flexpart10.2.tar.gz

RUN apt install -y patch
COPY flexpart.diff /compile/

RUN patch --verbose --directory /compile/flexpart10.2/src -p1 < /compile/flexpart.diff
RUN make -C /compile/flexpart10.2/src


# Third and final image is runtime for the flextraset and flexpart binaries
FROM ubuntu:18.04

RUN apt update -y
RUN apt install -y libnetcdff6 libgrib-api0
RUN apt install -y libemos-dev

COPY --from=flextraset /compile/flextraset/flextraset /usr/local/bin/
COPY --from=flexpart /compile/flexpart10.2/src/FP_ecmwf_gfortran /usr/local/bin/flexpart

WORKDIR /flexpart
COPY candidate_sites.txt /flexpart

# FIXME: Though we install the libgrib-api0 package these definitions are not
# part of it and it's not obviously clear how to install them. Thus we provide
# our own.
ADD grib_api.tgz /usr/share/

# Modified flexpart options
ADD options.tgz /flexpart/

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
