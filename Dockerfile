FROM rocker/r-ubuntu:22.04

ADD Rprofile.site /usr/lib/R/etc/Rprofile.site

# https://github.com/jlacko/RCzechia/blob/master/data-raw/Dockerfile
# for GDAL use
RUN apt-get update && apt-get -y install libexpat-dev

# for GEOS use
RUN apt-get update && apt-get -y install libsqlite3-dev

# the big three - cruel & unusual versions from source (takes about forever; should be on top of the dockerfile)

RUN apt-get update \
 && apt-get upgrade -y

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.550/quarto-1.4.550-linux-amd64.deb \
    && DEBIAN_FRONTEND=noninteractive apt install ./quarto-*-linux-amd64.deb \
    && rm quarto-*-linux-amd64.deb

RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN R -q -e 'install.packages("remotes"); remotes::install_github("rundel/checklist")'

# PROJ
RUN cd \
	&& wget http://download.osgeo.org/proj/proj-4.9.3.tar.gz \
	&& tar zxvf proj-4.9.3.tar.gz  \
	&& cd proj-4.9.3/ \
	&& ./configure \
	&& make -j $(nproc) \
	&& make install

# GDAL
RUN	cd \
	&& wget http://download.osgeo.org/gdal/2.2.3/gdal-2.2.3.tar.gz \
	&& tar zxvf gdal-2.2.3.tar.gz  \
	&& cd gdal-2.2.3 \
	&& ./configure \
	&& make -j $(nproc) \
	&& make install

# GEOS
RUN	cd \
	&& wget http://download.osgeo.org/geos/geos-3.6.2.tar.bz2 \
	&& bunzip2  geos-3.6.2.tar.bz2  \
	&& tar xvf geos-3.6.2.tar  \
	&& cd geos-3.6.2 \
	&& ./configure \
	&& make -j $(nproc)\
	&& make install

# other required packages; standard versions suffice...
# absolutely positively required on a single line (bo update a instal must be in the same keš)
RUN apt-get update && apt-get -y install libudunits2-dev
RUN apt-get update && apt-get -y install libxml2-dev
RUN apt-get update && apt-get -y install libv8-dev
RUN apt-get update && apt-get -y install libjq-dev
RUN apt-get update && apt-get -y install libprotobuf-dev
RUN apt-get update && apt-get -y install protobuf-compiler
RUN apt-get update && apt-get -y install libxtst6
RUN apt-get update && apt-get -y install libfontconfig1-dev
RUN apt-get update && apt-get -y install libharfbuzz-dev
RUN apt-get update && apt-get -y install libfribidi-dev
RUN apt-get update && apt-get -y install libfreetype6-dev
RUN apt-get update && apt-get -y install libpng-dev
RUN apt-get update && apt-get -y install libtiff5-dev
RUN apt-get update && apt-get -y install libjpeg-dev
RUN ldconfig


CMD ["bash"]

