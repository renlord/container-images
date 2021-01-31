#!/bin/sh

#if [ -z $TORHOST ]; then
#    TORHOST=tor
#    echo "TORHOST not set, defaults to 'tor'"
#fi
#
#socat TCP-LISTEN:9051,fork SOCKS4A:$TORHOST:127.0.0.1:9051,socksport=9051 &

socat -d TCP-LISTEN:${RPC_LISTEN_PORT:-7888},fork,reuseaddr UNIX-CONNECT:/config/bitcoin/lightning-rpc

echo "running as $(id)"

if [ -d ~/.lightning ]; then
    mkdir ~/.lightning && \
        ln -s /store/plugins $HOME/.lightning/plugins
    echo "symlinked /store/plugins to $HOME/.lightning/plugins"
fi

if [ -z "$1" ]; then
    lightningd --lightning-dir=/config
else
    lightningd --lightning-dir=/config &
    exec "$@"
fi
