#!/usr/bin/env bash

# Check if running as root
if [[ $EUID == 0 ]]; then
  # Install necessary packages
  microdnf -y install java-11-openjdk ncurses openssl procps python3 python3-pip curl gzip
  microdnf -y clean all

  # Create a group and user
  groupadd --gid 1000 $GUID
  useradd  --uid 1000 \
           --gid $GUID \
           --shell /bin/bash \
           --create-home $GUID

  # Create Jupyter directory and set permissions
  mkdir -p $JUPYTER_HOME
  chown $GUID:$GUID $JUPYTER_HOME
  chmod 770 $JUPYTER_HOME

  # Download and set up Coursier
  curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > ${JUPYTER_HOME}/cs
  chmod +x ${JUPYTER_HOME}/cs

  # Install Python packages
  python3 -m pip --no-cache-dir install -U pip setuptools
  python3 -m spylon_kernel install
else
  # Install Scala with Coursier
  ${JUPYTER_HOME}/cs install cs scala:${SCALA_VERSION} scalac:${SCALA_VERSION}

  # Clean up downloaded files
  rm -rf ${JUPYTER_HOME}/cs ${JUPYTER_HOME}/bootstrap.sh
fi

# Uncomment and customize the following section if you need to create a self-signed certificate and dhparam
#CERT_PATH="/etc/ssl/certs"
#openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
#  -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
#  -keyout ${CERT_PATH}/mykey.key -out ${CERT_PATH}/mycert.pem
#openssl dhparam -out ${CERT_PATH}/dhparam.pem 4096
