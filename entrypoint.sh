#!/bin/sh

echo "Creating a docker image with Gobra image tag: $INPUT_IMAGEVERSION"
docker build -t docker-action --build-arg "image_version=$INPUT_IMAGEVERSION" --build-arg "image_name=$INPUT_IMAGENAME" /docker-action

echo "Run Docker Action container"
docker run -e INPUT_CACHING -e INPUT_SRCDIRECTORY -e INPUT_PACKAGEDIRECTORIES -e INPUT_PACKAGES -e INPUT_JAVAXSS -e INPUT_JAVAXMX -e INPUT_GLOBALTIMEOUT -e INPUT_PACKAGETIMEOUT -e INPUT_VIPERBACKEND -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY \
  -v $RUNNER_WORKSPACE:$GITHUB_WORKSPACE \
  --workdir $GITHUB_WORKSPACE docker-action

