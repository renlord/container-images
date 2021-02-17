ARG ARCH

FROM ghcr.io/renlord/bitcoin:${ARCH} as bitcoin

FROM ${ARCH}/alpine

ARG VER

COPY entrypoint.sh /entrypoint.sh

ENV TINI_VERSION v0.19.0
ENV VERSION=${VER}

LABEL org.opencontainers.image.source https://github.com/renlord/container-images

RUN printenv && \
    apk add --no-cache sqlite python3 gmp libgcc openssl \
        boost boost-program_options drill \
        libevent libzmq su-exec tzdata socat tini && \
    apk add --no-cache --virtual .build-deps \
        autoconf automake build-base libtool \
        sqlite-dev zlib-dev gmp-dev wget libarchive-tools && \
    wget -4 https://github.com/ElementsProject/lightning/releases/download/${VERSION}/clightning-${VERSION}.zip && \
    bsdtar xf clightning-$VERSION.zip && \
    rm clightning-$VERSION.zip && \
    ln /usr/bin/python3 /usr/bin/python && \
    cd clightning-$VERSION && \
    ./configure && \
    make -j8 && \
    find lightningd -type f -executable -maxdepth 1 -exec strip {} \; && \
    find plugins -type f -executable -maxdepth 1 -exec strip {} \; && \
    make install && \
    apk del .build-deps && \
    cd .. && \
    rm -rf clightning-$VERSION && \
    adduser --uid 900 -D lightningman

COPY --from=bitcoin /usr/local/bin/bitcoin-cli /usr/local/bin/bitcoin-cli

USER lightningman

VOLUME ["/store", "/config", "/plugins"]

# 7888 unix domain socket forwarded to TCP listen
EXPOSE 9735 7888

ENTRYPOINT ["tini", "-g", "--", "/entrypoint.sh"]
