#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

sudo ln -sf $DIRNAME/mail-tunnel.service /etc/systemd/system/

sudo systemctl daemon-reload
