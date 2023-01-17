#!/usr/bin/env bash
APPNAME="jupyter"
REPO="kagaston"
SPARK_VERSION="3.3.1"

docker build -t "${REPO}/${APPNAME}:${SPARK_VERSION}" -t "${REPO}/${APPNAME}:latest" .
docker push --all-tags ${REPO}/${APPNAME}