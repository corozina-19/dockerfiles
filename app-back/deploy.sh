#!/bin/bash
set -e

###################################################

export folder_name=$4

##funtions
abort() {
  print_error "aborting..."
  exit
}

print() {
  echo "---INFO: " "$1"
}

print_error() {
  echo "---ERROR: " "$1"
}

load_env() {
  print "loading environment..."
  source ./env.sh
}

deploy() {
  load_env
  docker-compose up
}

build() {
  load_env
  docker-compose build
}

destroy() {
  load_env
  docker-compose down
}

clone() {
  print "moving to mnt folder"
  cd /mnt
  folder=$(ext-folder-name "$1")
  print "$folder"
  if [ ! -d "$folder" ]; then
    git clone "$1"
    cd "$folder"
  else
    cd "$folder"
    git pull --all
  fi

}

validation() {
  if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    abort
  fi

  if [ "$1" != "up" ]; then
    if [ "$1" != "build" ]; then
      if [ "$1" != "down" ]; then
        print_error "action ($1) invalid, allow 'build', 'up' or 'down'"
        abort
      fi
    fi
  fi

  if [ -z "$2" ]; then
    print_error "please specificate a repository of docker-compose"
    abort
  fi

  if [ -z "$3" ]; then
    print_error "please specificate a repository of app"
    abort
  fi

}

process-action() {
  if [ "$1" = "up" ]; then
    print "deploying compose file"
    deploy
  elif [ "$1" = "build" ]; then
    print "building compose file"
    build
  elif [ "$1" = "down" ]; then
    print "downing compose file"
    build
  else
    print_error "action ($1) invalid, allow 'build', 'up' or 'down'"
  fi
}

ext-folder-name(){

  total_len=${#1}
  str=${1%/*}
  len2=${#str}
  folder=${1:len2+1:total_len-5-len2}
  echo "$folder"

}
#https://github.com/martinezhenry/dockerfiles.git
#################################################

## validations
validation "$1" "$2" "$3"

print "Starting docker compose app-back..."
print "cloning repository of docker compose"
clone "$2"

print "cloning repository of app"
clone "$3"

cd /mnt
folder=$(ext-folder-name $2)
cd "$folder"

folder=$(ext-folder-name $3)
cd "$folder"

print "deploying compose file"
process-action "$1"
