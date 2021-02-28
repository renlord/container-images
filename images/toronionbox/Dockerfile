ARG ARCH
ARG VERSION

FROM ${ARCH}/alpine

COPY entrypoint.sh /entrypoint.sh

ENV VERSION=${VERSION}

RUN apk add --no-cache --virtual .build-deps \
    python3-dev && \
    apk add --no-cache python3 tor py3-psutil py3-setuptools tzdata tini py3-pip && \
    pip3 install theonionbox urllib3 && \
    mkdir /config && \
    chown -R root:root /var/lib/tor && \
    chmod +x /entrypoint.sh && \
    apk del .build-deps

VOLUME ["/config"]

# web interface at 8080
# tor proxy socket at 9050
EXPOSE 9050 9051 9080 9443 8080

CMD ["tini", "-g", "--", "/entrypoint.sh"]
