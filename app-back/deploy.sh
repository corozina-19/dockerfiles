#!/bin/bash
set -e

if (whoami != root); then
  echo "Please run as root"
  exit
fi

##config
export repository=https://github.com/martinezhenry/dockerfiles.git

##funtions
deploy() {
  docker-compose up
}

build() {
  docker-compose build
}

echo "Starting docker compose app-back..."

echo "moving to mnt folder"
cd /mnt

echo "cloning repository"
git clone $repository

echo "loading environment..."
source ./env.sh

echo "deploying compose file"

if [ "$1" = "deploy" ]; then
  echo "deploying compose file"
  deploy
elif [ "$1" = "buld" ]; then
  echo "deploying compose file"
  build
else
  echo "action ($1) invalid, allow build or deploy"
fi
