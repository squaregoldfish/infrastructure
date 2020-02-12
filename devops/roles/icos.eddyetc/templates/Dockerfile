# Lock down the r-base version, remember to bump this every now and then.
FROM r-base:3.6.2

# Install utilities and build dependencies.
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy \
        make git tree mg file \
        gfortran libcurl4-openssl-dev libxml2-dev libssl-dev

# Install additional R packages, some of these takes a long time.
RUN R -e "install.packages(c('xts'))"
RUN R -e "install.packages(c('data.table'))"
RUN R -e "install.packages(c('foreach'))"
RUN R -e "install.packages(c('doParallel'))"
RUN R -e "install.packages(c('car'))"
RUN R -e "install.packages(c('dygraphs'))"
RUN R -e "install.packages(c('robfilter'))"
RUN R -e "install.packages(c('gplots'))"
RUN R -e "install.packages(c('devtools'))"
RUN R -e "devtools::install_github('icos-etc/RFlux', force = TRUE)"

# Clone and compile eddypro.
WORKDIR /compile
RUN git clone https://github.com/LI-COR/eddypro-engine.git
RUN git -C eddypro-engine checkout v6.1.0
RUN make -C eddypro-engine/prj -f Makefile_rp_linux
RUN make -C eddypro-engine/prj -f Makefile_fcc_linux
RUN ln -s /compile/eddypro-engine/bin/linux/* /usr/local/bin/

# Now setup the actual code we're going to ru.n
WORKDIR /workdir

# This ADD will bust the build cache if the repo has changed.
# ADD https://api.github.com/repos/icos-etc/EC-Flux-nonICOS/commits /dev/null
# RUN git clone https://github.com/icos-etc/EC-Flux-nonICOS

# Setup entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
