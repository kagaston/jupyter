#!/usr/bin/env bash

# TODO add the CS install section to this build file
# TODO Add variables variable check --> declare defaults if not found

REPO="kagaston"
NAME="jupyter"
VERSION="3.3.1"

main () {
  build_docker_image
  push_docker_image
}

# TODO need to add directory in build path and the ln & export need to stay in the bootstrap file
install_cs () {
  echo "Installing the Scala installer Coursier"
  mkdir -p /opt/coursier/
  curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz \
  | gzip -d > /opt/coursier/cs
  chmod +x /opt/coursier/cs
}

build_docker_image () {
  docker build -t "${REPO}/${NAME}:${VERSION}" -t "${REPO}/${NAME}:latest" .

}

push_docker_image () {
  docker push --all-tags ${REPO}/${NAME}

}

###
main