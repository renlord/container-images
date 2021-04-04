#!/bin/sh

SECRET_ENVS=$(printenv | grep "/run/secrets")

for se in $SECRET_ENVS; do
    svar=$(echo "$se" | cut -d= -f1)
    sval=$(cat "$(echo "$se" | cut -d= -f2)")
    export $svar=$sval
done

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
