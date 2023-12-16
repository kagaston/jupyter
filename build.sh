#!/usr/bin/env bash

# Define default values for variables if not provided
REPO="${REPO:-kagaston}"
NAME="${NAME:-jupyter}"
VERSION="${VERSION:-3.3.1}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Build and tag the Docker image
docker build -t "${REPO}/${NAME}:${VERSION}" -t "${REPO}/${NAME}:latest" .

# Push all tags to the Docker repository
docker push --all-tags "${REPO}/${NAME}"
