#!/bin/sh

#if [ -z $TORHOST ]; then
#    TORHOST=tor
#    echo "TORHOST not set, defaults to 'tor'"
#fi
#

# WARN: assumes secure network environment between CLIGHTNING_HOST and this container.
# creates a local UNIX domain socket at ${HOME}/.lightning/lightning-rpc
# then tcp-connects to ${CLIGHTNING_HOST}
mkdir -p ${HOME}/.lightning
socat -d UNIX-LISTEN:${HOME}/.lightning/lightning-rpc,fork \
    TCP:${CLIGHTNING_HOST:-clightning}:${CLIGHTNING_RPC_TCP_PORT:-7888} &

echo "running as $(id)"

cd c-lightning-REST/ || exit 1

if [ -z "$1" ]; then
    node cl-rest.js
else
    node cl-rest.js &
    exec "$@"
fi
