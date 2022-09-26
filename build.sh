#!/bin/sh
PUSH=$1

BUILD_DIR="$(dirname $0)"
REPO_URL="https://github.com/lAmeR1/kaspa-rest-server.git"
REPO_DIR="$BUILD_DIR/work/kaspa-rest-server"

set -e

if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL" "$REPO_DIR"
  echo $(cd "$REPO_DIR" && git reset --hard HEAD~1)
fi

if $(cd "$REPO_DIR" && git pull | grep -qv "up to date"); then
  commitId=$(cd "$REPO_DIR" && git log -n1 --format="%h")
  tag=$(date -u +"%Y-%m-%d").$commitId
  echo
  echo "Git repo changed, building tag '$tag'."
  echo

  docker build --pull --build-arg REPO_DIR="$REPO_DIR" -t supertypo/kaspa-rest-server:$tag "$BUILD_DIR"
  docker tag supertypo/kaspa-rest-server:$tag supertypo/kaspa-rest-server:latest
  echo Tagged supertypo/kaspa-rest-server:latest

  if [ "$PUSH" = "push" ]; then
    docker push supertypo/kaspa-rest-server:$tag
    docker push supertypo/kaspa-rest-server:latest
  fi
else
  commitId=$(cd "$REPO_DIR" && git log -n1 --format="%h")
  echo "Git repo is still at '$commitId', skipping build."
fi

