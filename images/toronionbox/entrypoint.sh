#!/bin/sh

# launch onionbox
tor -f /config/torrc &
if [ -z "$1" ]; then
    theonionbox -c /config/theonionbox.cfg
else
    theonionbox -c /config/theonionbox.cfg &
    exec "$@"
fi
