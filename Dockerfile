FROM rocker/r2u

ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get upgrade -y

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

RUN apt-get update && \
  apt-get install -y libcurl4-openssl-dev \
libssl-dev \
libjq-dev \
libprotobuf-dev \
protobuf-compiler \
make \
libgeos-dev \
libudunits2-dev \
libgdal-dev \
gdal-bin \
libproj-dev \
libv8-dev
RUN R -e "remotes::install_github('r-spatial/sf')"
RUN R -e "install.packages('udunits2')"

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN R -q -e 'install.packages("remotes"); remotes::install_github("rundel/checklist")'

CMD ["bash"]

