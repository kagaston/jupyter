#!/usr/bin/env bash

# TODO add the CS install section to this build file
# TODO Add variables variable check --> declare defaults if not found

REPO="kagaston"
NAME="jupyter"
VERSION="3.3.1"


docker build -t "${REPO}/${NAME}:${VERSION}" -t "${REPO}/${NAME}:latest" .
docker push --all-tags ${REPO}/${NAME}

