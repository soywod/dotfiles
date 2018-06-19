#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"
TORRENT=/tmp/torrent
LOG=/tmp/transmission

if [ -f $TORRENT ]; then
  rm $TORRENT
fi

if [ -f $LOG ]; then
  rm $LOG
fi

killall -q -9 transmission-cli
while pgrep -u $UID -x transmission-cli >/dev/null; do sleep 1; done

mv "$1" /tmp/torrent
transmission-cli -f "$DIRNAME/finish.sh" $TORRENT>$LOG 2>&1 &

