#!/bin/sh

echo "Creating a docker image with Gobra image tag: $INPUT_IMAGEVERSION"
docker build -t docker-action --build-arg "image_version=$INPUT_IMAGEVERSION" --build-arg "image_name=$INPUT_IMAGENAME" /docker-action

# Directory where Gobra should write a stats.json file
STATS_TARGET="/stats/"

echo "Run Docker Action container"
docker run -e INPUT_CACHING -e INPUT_PROJECTLOCATION -e INPUT_INCLUDEPATHS -e INPUT_FILES -e INPUT_PACKAGES -e INPUT_EXCLUDEPACKAGES -e INPUT_CHOP \
  -e INPUT_VIPERBACKEND -e INPUT_JAVAXSS -e INPUT_JAVAXMX -e INPUT_GLOBALTIMEOUT -e INPUT_PACKAGETIMEOUT -e INPUT_HEADERONLY -e INPUT_STATSFILE \
  -e INPUT_MODULE -e INPUT_RECURSIVE -e INPUT_ASSUMEINJECTIVITYONINHALE -e INPUT_CHECKCONSISTENCY -e GITHUB_WORKSPACE -e GITHUB_REPOSITORY \
  -e STATS_TARGET -e DEBUG_MODE -v "$RUNNER_WORKSPACE:$GITHUB_WORKSPACE" -v "$INPUT_STATSFILE:$STATS_TARGET" \
  --workdir "$GITHUB_WORKSPACE" docker-action