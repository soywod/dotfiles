#!/bin/bash

USER='pi'
IP=$(dig +short mail.soywod.me)
PORT=80
IMAPS='mail.soywod.me:993:localhost:993'
SMTPS='mail.soywod.me:587:localhost:587'
WEBDAV='5232:localhost:5232'

HOST="$USER@$IP"
PORT="-p $PORT"
IMAPS="-L $IMAPS"
SMTPS="-L $SMTPS"
WEBDAV="-L $WEBDAV"
NO_CMD='-N'
NO_PROMPT='-oStrictHostKeyChecking=no'

ssh $HOST $PORT $IMAPS $SMTPS $WEBDAV $NO_CMD $NO_PROMPT
