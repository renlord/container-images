#!/bin/sh

if [ -z $TORHOST ]; then
    TORHOST=tor
    echo "TORHOST not set, defaults to 'tor'"
fi

# freenode tor hidden service
socat TCP-LISTEN:4321,fork SOCKS4A:$TORHOST:freenodeok2gncmy.onion:6697,socksport=9050 &

if [ -z "$1" ]; then
    znc -f -d /config/znc
else
    znc -f -d /config/znc &
    exec "$@"
fi
