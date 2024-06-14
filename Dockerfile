FROM rocker/r-ubuntu:22.04

ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get upgrade -y

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

# stuff for the tmaptools/rmapshaper/geojsonio etc stack:
RUN apt-get install -y libv8-3.14-dev libprotobuf-dev protobuf-compiler libcairo2-dev
RUN add-apt-repository -y ppa:opencpu/jq
RUN apt-get update
RUN apt-get install -y libjq-dev

RUN Rscript -e 'install.packages(c("sf", "lwgeom", "covr", "raster"), dependencies = TRUE, repos = "https://cloud.r-project.org")'
RUN git clone   https://github.com/r-spatial/sf.git
RUN R CMD build --no-build-vignettes sf
RUN R CMD INSTALL sf_*tar.gz

RUN apt-get install -y pandoc pandoc-citeproc

RUN R CMD check --as-cran sf_*tar.gz


RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN R -q -e 'install.packages("remotes"); remotes::install_github("rundel/checklist")'

CMD ["bash"]

