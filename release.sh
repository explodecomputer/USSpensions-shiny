#!/bin/bash

set -ex

## See https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

# ensure we're up to date
git pull

# bump version
version=`cat version.txt | cut -d " " -f 1`
echo "version: $version"

# run build
docker build -t USSpensions-shiny:latest .

# run container
docker stop USSpensions-shiny || true
docker rm USSpensions-shiny || true
docker run -d --name USSpensions-shiny -p 8011:3838 --restart=always USSpensions-shiny:latest
