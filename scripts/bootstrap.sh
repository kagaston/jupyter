#!/usr/bin/env bash
set -euo pipefail

# Provision the Jupyter Lab container in two phases:
#   Phase 1 (root):     Install system packages, create user, download Coursier
#   Phase 2 (non-root): Install Scala via Coursier, clean up bootstrap artifacts

if [[ $EUID == 0 ]]; then
  microdnf -y install java-11-openjdk ncurses openssl procps python3 python3-pip curl gzip
  microdnf -y clean all

  groupadd --gid 1000 "$GUID"
  useradd --uid 1000 \
    --gid "$GUID" \
    --shell /bin/bash \
    --create-home "$GUID"

  mkdir -p "$JUPYTER_HOME"
  chown "$GUID":"$GUID" "$JUPYTER_HOME"
  chmod 770 "$JUPYTER_HOME"

  curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d >"${JUPYTER_HOME}/cs"
  chmod +x "${JUPYTER_HOME}/cs"

  python3 -m pip --no-cache-dir install -U pip setuptools
  python3 -m pip --no-cache-dir install -U py4j pyspark jupyterlab spylon-kernel
  python3 -m spylon_kernel install
else
  "${JUPYTER_HOME}/cs" install cs "scala:${SCALA_VERSION}" "scalac:${SCALA_VERSION}"
  rm -rf "${JUPYTER_HOME}/cs" "${JUPYTER_HOME}/bootstrap.sh"
fi
