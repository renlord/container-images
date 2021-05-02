ARG ARCH=""

FROM ${ARCH}/alpine

ARG GOBIN=""

COPY ./${GOBIN} /gotify/server

RUN apk add --no-cache curl && \
    chmod +x /gotify/server && \
    mkdir /data && \
    mkdir /config && \
    mkdir /etc/gotify

COPY ./config.yml /etc/gotify/config.yml

HEALTHCHECK --interval=30s --timeout=60s --retries=5 CMD curl -sS http://127.0.0.1/health || exit 1

VOLUME /data
VOLUME /etc/gotify/

EXPOSE 80

CMD /gotify/server
