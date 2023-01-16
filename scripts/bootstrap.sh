#!/usr/bin/env bash
main () {
  install_tini_init
  install_java
  install_python
  create_app_user
  configure_app_dir
  install_python_dependencies
  install_jupyter
  install_cs
  install_scala
  install_scala_jupyter_kernel
  # generate_self_signed_key
}

install_tini_init () {
  URI="https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini"
  curl -sSfL $URI -o /tini
  curl -sSfL ${URI}.asc -o /tini.asc
  gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
  gpg --batch --verify /tini.asc /tini
  chmod +x /tini
}

install_java () {
  microdnf -y install java-11-openjdk ncurses
  microdnf -y clean all
}

install_python () {
  microdnf -y install python3 python3-pip
  microdnf -y clean all
  alias pip="python3 -m pip --no-cache-dir --upgrade --compile --user ${GUID}"
}

install_cs () {
  # TODO add pgp and hash validation
  echo "Installing the Scala installer Coursier"
  mkdir -p /opt/coursier/
  curl -sSfL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > /opt/coursier/cs
  chmod +x /opt/coursier/cs
  ln -s /opt/coursier/cs /usr/bin/cs
  export PATH="$PATH:/root/.local/share/coursier/bin"
}

#validate () {
#  # TODO add validation of package pgp and hash
#  curl -sSfL ${APACHE_URL}/spark/KEYS -o KEYS
#  curl -sSfL ${URI}.asc -o apache-spark.tgz.asc
#  gpg --import KEYS
#  gpg --verify apache-spark.tgz.asc apache-spark.tgz
#  # TODO write hash check
#  curl -sSfL ${URI}.sha512 -o apache-spark.tgz.sha512
#}


install_scala () {
  dnf install java-11-openjdk -y # scala scalac dependency
  cs install scala:${SCALA_VERSION} scalac:${SCALA_VERSION}
}

install_python_dependencies () {
  pip install pip setuptools py4j
}

install_jupyter () {
  pip install pyspark jupyterlab
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
           --shell /bin/bash \
           --create-home $GUID
}

configure_app_dir () {
  mkdir -p $JUPYTER_HOME
  chown $GUID:$GUID $JUPYTER_HOME
  # chmod 770 $JUPYTER_HOME

}

# enable_logging_to_docker () {
#  # TODO configure logging
#  #  ln -sf /dev/stdout $SPARK_MASTER_LOG
#  #  ln -sf /dev/stdout $SPARK_WORKER_LOG
#}

generate_self_signed_key () {
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout mykey.key -out mycert.pem
#  openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
}

###############
#<<< This is calling the main function, please do not place code past this point.
main