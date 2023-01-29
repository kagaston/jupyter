FROM oraclelinux:9-slim  as base

MAINTAINER "Kody Gaston" "kody.gaston@msn.com"
LABEL version="1.0.1"

ENV GUID=jupyter \
    JUPYTER_HOME=/opt/workspace \
    SCALA_VERSION=3.2.2 \
    SPARK_VERSION=3.3.1 \
    PATH="/home/jupyter/.local/share/coursier/bin:/home/jupyter/.local/bin:/home/jupyter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"


WORKDIR ${JUPYTER_HOME}

COPY scripts .

RUN bash bootstrap.sh

# Jupyter Notebooks Environment
FROM base as jupyter

USER ${GUID}

RUN bash bootstrap.sh

EXPOSE 8888

CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

