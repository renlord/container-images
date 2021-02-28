ARG ARCH

FROM alpine as builder
ARG VERSION

ENV STANDALONE=1

RUN apk add --no-cache git wget npm nodejs libarchive-tools bash python3 perl

RUN npm config set unsafe-perm true

# Install Spark
RUN wget https://github.com/shesek/spark-wallet/archive/${VERSION}.tar.gz 
RUN bsdtar xf ${VERSION}.tar.gz
RUN cd spark-wallet-${VERSION:1} && \
    npm install && \
    npm run dist:npm && \
    npm prune --production && \
    find . -mindepth 1 -maxdepth 1 \
           ! -name '*.json' ! -name dist ! -name LICENSE ! -name node_modules ! -name scripts \
           -exec rm -r "{}" \;
RUN mv spark-wallet-${VERSION:1} spark-wallet

# Prepare final image
FROM ${ARCH}/alpine
ARG VERSION

LABEL org.opencontainers.image.source https://github.com/renlord/container-images

ENV STANDALONE=1

COPY --from=builder /spark-wallet /spark-wallet

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache nodejs socat tini su-exec && \
    ln -s /spark-wallet/dist/cli.js /usr/bin/spark-wallet && \
    adduser --uid 900 -D sparkman

ENV CONFIG=/config/config
ENV TLS_PATH=/config/tls
ENV TOR_PATH=/config/tor
ENV COOKIE_FILE=/store/cookie
ENV HOST=0.0.0.0

USER sparkman

VOLUME /store
VOLUME /config
ENTRYPOINT [ "tini", "-g", "--", "/entrypoint.sh" ]

EXPOSE 9737
