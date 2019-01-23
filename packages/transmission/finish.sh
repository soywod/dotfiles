#!/bin/bash

TORRENT=/tmp/torrent
LOG=/tmp/transmission

killall transmission-cli
[ -f $TORRENT ] && rm $TORRENT
[ -f $LOG ] && rm $LOG
