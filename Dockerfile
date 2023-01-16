FROM oraclelinux:9-slim  as base

MAINTAINER "Kody Gaston" "kody.gaston@msn.com"
LABEL version="1.0.1"

ENV GUID=jupyter \
    JUPYTER_HOME=/opt/workspace \
    SCALA_VERSION=3.2.2 \
    SCALA_HOME=/usr/share/scala \
    SPARK_VERSION=3.3.1 \
    TINI_VERSION=v0.19.0

WORKDIR ${JUPYTER_HOME}

COPY scripts .

RUN bash bootstrap.sh && rm -rf bootstrap.sh

ENTRYPOINT ["/tini", "--"]

# Jupyter Notebooks Environment
FROM base as jupyter

USER ${GUID}

EXPOSE 8888

CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''"]
#CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--certfile=mycert.pem", "--keyfile mykey.key"]

