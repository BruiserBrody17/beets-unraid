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

exec gosu beets "$@"
