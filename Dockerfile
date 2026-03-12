FROM oraclelinux:9-slim AS base

LABEL maintainer="Kody Gaston <kody.gaston@msn.com>" \
      version="1.0.1" \
      org.opencontainers.image.source="https://github.com/kagaston/jupyter"

ENV GUID=jupyter \
    JUPYTER_HOME=/opt/workspace \
    SCALA_VERSION=3.2.2 \
    SPARK_VERSION=3.3.1 \
    PATH="/home/jupyter/.local/share/coursier/bin:/home/jupyter/.local/bin:/home/jupyter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR ${JUPYTER_HOME}

COPY scripts .

RUN bash bootstrap.sh

FROM base AS jupyter

USER ${GUID}

RUN bash bootstrap.sh

EXPOSE 8888

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8888/api/status || exit 1

CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''"]
