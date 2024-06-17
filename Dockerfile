FROM rocker/r2u

ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

RUN apt-get update \
 && apt-get upgrade -y

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

RUN apt-get update && \
  apt-get install -y libproj22 libudunits2-dev libgdal30 && \
  rm -rf /var/lib/apt/lists/*
RUN R -e "install.packages('sf')"

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN R -q -e 'install.packages("remotes"); remotes::install_github("rundel/checklist")'

CMD ["bash"]

