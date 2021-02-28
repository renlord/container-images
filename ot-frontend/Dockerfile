ARG ARCH

FROM alpine as builder

ARG VERSION

RUN apk add --no-cache --virtual .build-deps libarchive-tools wget \
        nodejs npm && \
    npm install -g yarn && \
    apk add --no-cache nginx gettext curl && \
    wget https://github.com/owntracks/frontend/archive/$VERSION.tar.gz && \
    bsdtar xf $VERSION.tar.gz && \
    mv frontend-${VERSION:1} source && \
    cd source && \
    yarn install && \
    yarn build

FROM ${ARCH}/alpine

RUN mkdir -p /usr/share/nginx/ && \
    mkdir -p /run/nginx/

COPY --from=builder /source/dist /usr/share/nginx/html

EXPOSE 80
ENV LISTEN_PORT=80 \
  SERVER_HOST=otrecorder \
  SERVER_PORT=80

COPY nginx.tmpl /etc/nginx/nginx.tmpl

CMD /bin/sh -c "envsubst '\${SERVER_HOST} \${SERVER_PORT} \${LISTEN_PORT}' < /etc/nginx/nginx.tmpl > /etc/nginx/nginx.conf && nginx -g 'daemon off;' || ( env; cat /etc/nginx/nginx.conf )"
