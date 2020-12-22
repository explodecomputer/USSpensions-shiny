FROM rocker/tidyverse:latest

# Based on https://github.com/rocker-org/shiny

MAINTAINER Gibran Hemani "g.hemani@bristol.ac.uk"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev

RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb


RUN R -e "install.packages(c('remotes', 'shiny', 'shinydashboard', 'plotly', 'shinycssloaders'), repos='https://cran.rstudio.com/')"

RUN rm -r /srv/shiny-server/*
RUN mkdir -p /srv/shiny-server/
COPY . /srv/shiny-server/

RUN echo "hello"
RUN sudo su - -c "R -e \"remotes::install_github('explodecomputer/USSpensions')\"" 

EXPOSE 3838


COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
