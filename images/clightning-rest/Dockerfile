ARG ARCH

FROM ${ARCH}/alpine

ARG VER

ENV VERSION=${VER}

LABEL org.opencontainers.image.source https://github.com/renlord/container-images

# cl-rest plugin
# https://github.com/Ride-The-Lightning/c-lightning-REST
RUN apk add --no-cache nodejs openssl socat tini && \
    apk add --virtual .build-deps --no-cache wget npm wget libarchive-tools && \
    wget https://github.com/Ride-The-Lightning/c-lightning-REST/archive/${VERSION}.tar.gz && \
    bsdtar xf ${VERSION}.tar.gz && \
    mv c-lightning-REST-${VERSION:1} c-lightning-REST && \
    rm ${VERSION}.tar.gz && \
    cd c-lightning-REST && \
    npm install --only=production && \
    apk del .build-deps && \
    adduser -u 900 -D rtlman && \
    mkdir ./certs && \
    chown -R rtlman:rtlman .

ENV PORT 3001
ENV DOCPORT 4001
ENV PROTOCOL https
ENV EXECMODE production

USER rtlman

EXPOSE 3001
EXPOSE 4001

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["tini", "-g", "--", "/entrypoint.sh"]
