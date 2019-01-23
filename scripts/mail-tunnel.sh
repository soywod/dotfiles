#!/bin/bash

USER='pi'
IP='192.168.0.2'
PORT=60022
IMAPS='mail.soywod.me:993:localhost:993'
SMTPS='mail.soywod.me:587:localhost:587'
WEBDAV='5232:localhost:5232'

HOST="$USER@$IP"
PORT="-p $PORT"
IMAPS="-L $IMAPS"
SMTPS="-L $SMTPS"
WEBDAV="-L $WEBDAV"

sudo ssh $HOST $PORT $IMAPS $SMTPS $WEBDAV
