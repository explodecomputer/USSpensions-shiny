#!/bin/bash

set -ex

## See https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

# ensure we're up to date
git pull

# bump version
version=`cat version.txt | cut -d " " -f 1`
echo "version: $version"

# run build
docker build -t usspensions-shiny:latest .

# run container
docker stop usspensions-shiny || true
docker rm usspensions-shiny || true
docker run -d --name usspensions-shiny -p 8011:3838 --restart=always usspensions-shiny:latest
