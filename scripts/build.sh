#!/usr/bin/env bash
set -euo pipefail

# Build the kagaston/jupyter Docker image. Push only when PUSH=true.
# Usage: build.sh [version]

if ! command -v docker &>/dev/null; then
  echo "Error: docker is required" >&2
  exit 1
fi

readonly REPO="kagaston"
readonly NAME="jupyter"
readonly VERSION="${1:-3.3.1}"

docker build -t "${REPO}/${NAME}:${VERSION}" -t "${REPO}/${NAME}:latest" .

if [[ "${PUSH:-false}" == "true" ]]; then
  docker push --all-tags "${REPO}/${NAME}"
fi
