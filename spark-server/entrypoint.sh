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
rm -f ${HOME}/.lightning/lightning-rpc
socat -d UNIX-LISTEN:${HOME}/.lightning/lightning-rpc,fork \
    TCP:${CLIGHTNING_HOST:-clightning}:${CLIGHTNING_RPC_TCP_PORT:-7888} &

# to change user set container runtime user
echo "running as $(whoami)"

cd spark-wallet/ || exit 1

# WARN: assumes secure network environment and a TRUSTED TLS proxy.
if [ -z "$1" ]; then
    spark-wallet --no-tls --print-key
else
    spark-wallet "$@"
fi
