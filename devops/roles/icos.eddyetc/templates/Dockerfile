# Lock down the r-base version, remember to bump this every now and then.
# https://hub.docker.com/_/r-base/
FROM r-base:4.0.3

# Install utilities and build dependencies.
RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -qy \
        make git tree mg file nano gfortran-9 \
        libcurl4-openssl-dev libxml2-dev libssl-dev \
        libgit2-dev \
    && apt-get clean && rm -rf /var/lib/apt

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
RUN R -e "install.packages(c('pbapply'))"

RUN ln -s /usr/bin/gfortran-9 /usr/local/bin/gfortran

# Clone and compile eddypro.
WORKDIR /compile
RUN git clone https://github.com/LI-COR/eddypro-engine.git
RUN git -C eddypro-engine checkout v7.0.6
RUN make -C eddypro-engine/prj rp fcc
# <2021-01-11> Eddypro v7.0.6 did not build with the latest gfortran (version
# 10) out of the box, it had compilation errors. Building it with gfortran
# version 9 worked, hence this workaround. That's why gfortran-9 is installed
# explicitly (instead of just gfortran)
RUN ln -s /compile/eddypro-engine/bin/linux/* /usr/local/bin/

# This R package comes after the other since it's ICOS ETC code and might
# change more frequently.
# First bust the cache if anything has changed.
ADD https://api.github.com/repos/icos-etc/RFlux/commits /dev/null
RUN R -e "devtools::install_github('icos-etc/RFlux', force = TRUE)"

# Now setup the actual code we're going to run.
WORKDIR /workdir

# This ADD will bust the build cache if the repo has changed.
# ADD https://api.github.com/repos/icos-etc/EC-Flux-nonICOS/commits /dev/null
# RUN git clone https://github.com/icos-etc/EC-Flux-nonICOS

# Setup entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
