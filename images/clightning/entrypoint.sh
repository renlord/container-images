#!/bin/sh

#if [ -z $TORHOST ]; then
#    TORHOST=tor
#    echo "TORHOST not set, defaults to 'tor'"
#fi
#

#socat TCP-LISTEN:9051,fork SOCKS4A:$TORHOST:127.0.0.1:9051,socksport=9051 &
socat -d TCP-LISTEN:${RPC_LISTEN_PORT:-7888},fork,reuseaddr UNIX-CONNECT:/config/bitcoin/lightning-rpc &

# resolve dns to Tor
TORHOST_IP_PREFIX=$(drill ${TORHOST:-onionbox} A | grep ${TORHOST:-onionbox} | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
[ -z $TORHOST_IP_PREFIX ] && echo "cant find TORHOST_IP_PREFIX, bailing!" && exit 1

INTERFACE_FOR_TORHOST=$(ip route | grep -Eo "src ${TORHOST_IP_PREFIX}\.[0-9]+" | cut -d' ' -f 2)

cp -f /config/config.template /config/config
sed -i "s/%INTERFACE_FOR_TORHOST%/${INTERFACE_FOR_TORHOST}/g" /config/config

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
