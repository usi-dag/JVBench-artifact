#!/bin/bash

. config

function check_dependency() (
  cmd=$1
  error_message=$2

  cmd_bin=`which $1`
  if [ -z ${cmd_bin} ]; then
      echo "$TOOL_NAME requires Docker"
      echo "Please install node from https://nodejs.org/"
      exit 1
  fi
)

echo "Checking dependencies..."
check_dependency "docker" "Please install Docker from https://docs.docker.com/install/"

echo "Checking docker service status..."
systemctl is-active --quiet docker
status=$?
if [ $status -ne 0 ]; then
    echo "Starting docker service..."
    sudo service docker start
fi

username=$(whoami)
if ! groups $username | grep -q '\bdocker\b'; then
    echo "Adding user to docker group..."
    sudo usermod -a -G docker $username
    echo "User " $username " added to group docker"
    echo "Please logout and login"
    exit 13
fi

echo "Loading $TOOL_NAME docker image... (this may take several minutes)"
mkdir -p output
docker load -i $DOCKER_IMG_FILENAME

cmd=$1
shift

mkdir -p $(pwd)/$SHARED_VOLUME
docker run -v $(pwd)/$SHARED_VOLUME:/artifact/$SHARED_VOLUME -t $DOCKER_IMAGE_NAME ./$cmd.sh $@
