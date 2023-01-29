#!/usr/bin/env bash


#!/usr/bin/env bash

if [[ $EUID == 0 ]]
  then
    microdnf -y install java-11-openjdk ncurses openssl procps python3 python3-pip curl gzip
    microdnf -y clean all

    groupadd --gid 1000 $GUID
    useradd  --uid 1000 \
             --gid $GUID \
             --shell /bin/bash \
             --create-home $GUID

    mkdir -p $JUPYTER_HOME
    chown $GUID:$GUID $JUPYTER_HOME
    chmod 770 $JUPYTER_HOME

    curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > ${JUPYTER_HOME}/cs
    chmod +x ${JUPYTER_HOME}/cs

    python3 -m pip --no-cache-dir install -U pip setuptools
    python3 -m pip --no-cache-dir install -U py4j pyspark jupyterlab spylon-kernel
    python3 -m spylon_kernel install
  else
    ${JUPYTER_HOME}/cs install cs scala:${SCALA_VERSION} scalac:${SCALA_VERSION}
    rm -rf ${JUPYTER_HOME}/cs ${JUPYTER_HOME}/bootstrap.sh
fi











### "Creating self-signed cert and dhparam"
#CERT_PATH="/etc/ssl/certs"
#openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
#  -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
#  -keyout ${CERT_PATH}/mykey.key -out ${CERT_PATH}/mycert.pem
#openssl dhparam -out ${CERT_PATH}/dhparam.pem 4096







