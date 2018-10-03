FROM r-base

RUN apt-get update -y && apt-get upgrade -y
RUN apt install -y make git gfortran libcurl4-openssl-dev

# Install additional R packages, some of these takes a long time.
RUN R -e "install.packages(c('xts'))"
RUN R -e "install.packages(c('data.table'))"
RUN R -e "install.packages(c('foreach'))"
RUN R -e "install.packages(c('doParallel'))"
RUN R -e "install.packages(c('car'))"
RUN R -e "install.packages(c('dygraphs'))"
RUN R -e "install.packages(c('robfilter'))"
RUN R -e "install.packages(c('gplots'))"

WORKDIR /compile
RUN git clone https://github.com/LI-COR/eddypro-engine.git
RUN git -C eddypro-engine checkout {{ eddyetc_eddy_pro_git_tag }}
RUN make -C eddypro-engine/prj -f Makefile_rp_linux
RUN make -C eddypro-engine/prj -f Makefile_fcc_linux

# Install debugging utilities
RUN apt install -y tree mg file

WORKDIR /workdir
RUN bash -c "mkdir -p data /workdir/eddypro/{bin,processing_setup,tmp}"

# The EC_Processing_CP_*.R script expects to find its binaries here.
RUN ln -s /compile/eddypro-engine/bin/linux/* /workdir/eddypro/bin

COPY processing_setup/* /workdir/eddypro/processing_setup/
COPY EC_Processing_CP_v0.R .

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


