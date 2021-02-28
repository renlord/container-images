ARG ARCH
ARG VERSION

FROM ${ARCH}/alpine

COPY entrypoint.sh /entrypoint.sh
COPY config.mk /config.mk
COPY recorder-health.sh /usr/local/sbin/recorder-health.sh

COPY ot-recorder/ /usr/local/source/

ENV VERSION=${VERSION}
ENV LUA_SCRIPT=/lua/otr.lua

RUN apk add --no-cache --virtual .build-deps \
        curl-dev libconfig-dev make \
        musl-dev mosquitto-dev wget alpine-sdk \
        luarocks \
    && apk add --no-cache \
        libcurl libconfig-dev mosquitto-dev lmdb-dev libsodium-dev lua5.2-dev musl curl jq \
    && luarocks-5.2 install Lua-cURL \
    && mkdir -p /config \
    && cd /usr/local/source \
    && mv /config.mk ./ \
    && make \
    ; make install \
    ; cd / \
    && chmod 755 /entrypoint.sh \
    && rm -rf /usr/local/source \
    && chmod 755 /usr/local/sbin/recorder-health.sh \
    && apk del .build-deps

COPY ot-recorder/contrib/lua /lua

VOLUME ["/store", "/config"]

COPY recorder.conf /config/recorder.conf

HEALTHCHECK CMD /usr/local/sbin/recorder-health.sh

EXPOSE 8083

ENTRYPOINT ["/entrypoint.sh"]
