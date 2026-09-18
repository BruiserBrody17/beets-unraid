#!/bin/bash
set -e

PUID="${PUID:-99}"
PGID="${PGID:-100}"
UMASK="${UMASK:-022}"

if [ "$(id -g beets)" != "$PGID" ]; then
    groupmod -o -g "$PGID" beets
fi
if [ "$(id -u beets)" != "$PUID" ]; then
    usermod -o -u "$PUID" beets
fi

umask "$UMASK"
chown -R "$PUID:$PGID" /config

echo "beets-custom: running as PUID=$PUID PGID=$PGID UMASK=$UMASK"

# Run the target command as a background child instead of exec'ing into
# it. This script (bash) stays as PID 1, and PID 1 in a container does
# NOT get default signal handling -- only signals it explicitly traps.
# `sleep infinity` (or anything else) as PID 1 would just ignore SIGTERM
# from `docker stop` and hang until the grace period expires and it gets
# SIGKILLed. Trapping here and forwarding to the child fixes that.
child=0
term() {
    [ "$child" -ne 0 ] && kill -TERM "$child" 2>/dev/null
}
trap term TERM INT

gosu beets "$@" &
child=$!
wait "$child"
