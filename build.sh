#!/bin/sh
PUSH=$1

set -e

docker build --pull -t supertypo/kaspa-rest-server:latest $(dirname $0)
docker tag supertypo/kaspa-rest-server:latest supertypo/kaspa-rest-server:$(date +"%Y-%m-%d")
echo Tagged supertypo/kaspa-rest-server:$(date +"%Y-%m-%d")

if [ "$PUSH" = "push" ]; then
  docker push supertypo/kaspa-rest-server:$(date +"%Y-%m-%d")
  docker push supertypo/kaspa-rest-server:latest
fi

