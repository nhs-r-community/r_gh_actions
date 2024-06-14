FROM rocker/r-ubuntu:22.04

ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get upgrade -y
 
RUN apt-get install -y --no-install-recommends \
    libudunits2-dev libgdal-dev libgeos-dev \
    libproj-dev pandoc libmagick++-dev \
    libglpk-dev libnode-dev \
    wget git rsync 

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

RUN install.r remotes rmarkdown quarto tidyverse sf \
 && installGithub.r rundel/checklist

RUN R -q -e 'install.packages("remotes"); remotes::install_github("rundel/checklist")'

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

CMD ["bash"]

