#!/bin/sh

# Load Default recorder.conf if not available
if [ ! -f /config/recorder.conf ]; then
	  cp /etc/default/recorder.conf /config/recorder.conf
fi

ot-recorder --initialize
if [ ! -z $LUA_SCRIPT ]; then
    ot-recorder --lua-script "$LUA_SCRIPT" "$@"
else
    ot-recorder "$@"
fi
