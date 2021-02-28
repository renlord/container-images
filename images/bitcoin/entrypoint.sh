#!/bin/sh

if [ -z $TORHOST ]; then
    TORHOST=tor
    echo "TORHOST not set, defaults to 'tor'"
fi



su-exec ${UID:-900}:${GID:-900} socat TCP-LISTEN:9051,fork SOCKS4A:$TORHOST:127.0.0.1:9051,socksport=9051 &

if [ -z "$1" ]; then
    su-exec ${UID:-900}:${GID:-900} bitcoind -printtoconsole -conf=/config/bitcoin.conf
else
    su-exec ${UID:-900}:${GID:-900} bitcoind -printtoconsole -conf=/config/bitcoin.conf &
    exec "$@"
fi
