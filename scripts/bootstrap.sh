#!/usr/bin/env bash

# TODO Remove the CS section to the build file
#
main () {
  install_linux_dependencies
  install_python
  create_app_user
  configure_app_dir
  install_python_dependencies
  install_cs
  install_scala
  install_scala_jupyter_kernel
}

install_linux_dependencies () {
  microdnf -y install java-17-openjdk ncurses openssl procps python3 python3-pip
  microdnf -y clean all
  alias pip="python3 -m pip --no-cache-dir --upgrade --compile --user ${GUID}"
}

install_cs () {
  echo "Installing the Scala installer Coursier"
  mkdir -p /opt/coursier/
  curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /opt/coursier/cs
  chmod +x /opt/coursier/cs
  ln -s /opt/coursier/cs /usr/bin/cs
  export PATH="$PATH:/root/.local/share/coursier/bin"
}

install_scala () {
  cs install scala:${SCALA_VERSION} scalac:${SCALA_VERSION}
}

install_python_dependencies () {
  pip install pip setuptools
  pip install py4j jupyterlab # pyspark ##<-- Removed pyspark as it is not performant in cluster mode for spark
  export PATH=$PATH:/home/jupyter/.local/bin
}

install_scala_jupyter_kernel () {
  pip install spylon-kernel
  python3 -m spylon_kernel install
}

create_app_user () {
  groupadd --gid 1000 $GUID
  useradd  --uid 1000 \
           --gid $GUID \
           --system \
           --shell /bin/bash \
           --create-home $GUID
}

configure_app_dir () {
  mkdir -p $JUPYTER_HOME
  chown $GUID:$GUID $JUPYTER_HOME
  chmod 770 $JUPYTER_HOME
}

generate_self_signed_key () {
  echo "Creating self-signed cert and dhparam"
  CERT_PATH="/etc/ssl/certs"
  openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout ${CERT_PATH}/mykey.key -out ${CERT_PATH}/mycert.pem
  openssl dhparam -out ${CERT_PATH}/dhparam.pem 4096
}

###############
#<<< This is calling the main function, please do not place code past this point.
main