ARG ARCH
ARG VERSION

FROM ${ARCH}/alpine

COPY entrypoint.sh /entrypoint.sh

ENV VERSION=${VERSION}

RUN apk add --no-cache znc znc-extra znc-dev socat zlib && \
    apk add --no-cache --virtual .build-deps build-base git icu-dev openssl-dev zlib-dev && \
    mkdir -p /config/znc && \
    chown -R 10000:10000 /config/znc && \
    chmod +x /entrypoint.sh && \
    git clone --depth=1 https://github.com/renlord/znc-backlog /znc-backlog && \
    cd /znc-backlog && \
    make && \
    cp backlog.so /usr/lib/znc/ && \
    cd .. && \
    rm -rf /znc-backlog && \
    apk del .build-deps

# BIND MOUNT this volume
VOLUME ["/config/znc"]

USER 10000:10000

# web interface at 8080
# irc listener socket at 36666 (needs to be published in host mode)
EXPOSE 36666 8080

CMD ["/entrypoint.sh"]
