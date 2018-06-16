#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"
TORRENT=/tmp/torrent
LOG=/tmp/transmission

mv "$1" /tmp/torrent
transmission-cli -f "$DIRNAME/finish.sh" $TORRENT >$LOG 2>&1 &

