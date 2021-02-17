ARG ARCH

FROM ${ARCH}/alpine

ARG VERSION

COPY entrypoint.sh /entrypoint.sh

ENV VERSION=${VERSION}

LABEL org.opencontainers.image.source https://github.com/renlord/container-images

RUN printenv && \
    apk add --no-cache --virtual .build-deps \
        autoconf automake boost-dev build-base \
        chrpath file gnupg libevent-dev \
        openssl-dev libtool linux-headers protobuf-dev \
        zeromq-dev libarchive-tools wget && \
    apk add --no-cache openssl boost boost-program_options \
        libevent libzmq su-exec socat tzdata && \
    wget https://github.com/bitcoin/bitcoin/archive/${VERSION}.tar.gz && \
    bsdtar xf ${VERSION}.tar.gz && \
    rm ${VERSION}.tar.gz && \
    mv bitcoin-${VERSION:1} bitcoin-source && \ 
    cd bitcoin-source && \
    ./autogen.sh && \
    ./configure --disable-tests --disable-bench --disable-ccache \
        --with-gui=no --disable-wallet && \
    make -j8 && \
    make install && \
    strip $(which bitcoin-cli) && \
    strip $(which bitcoin-tx) && \
    strip $(which bitcoind) && \
    apk del .build-deps && \
    cd .. && \
    rm -rf bitcoin-source

VOLUME ["/store", "/config"]

EXPOSE 8332 8333 18332 18333 18444

ENTRYPOINT ["/entrypoint.sh"]
