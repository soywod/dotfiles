#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/gammastep ~/.config/systemd/user
cp $DIRNAME/config.ini ~/.config/gammastep/config.ini
cp $DIRNAME/service.ini ~/.config/systemd/user/gammastep.service

systemctl --user daemon-reload
systemctl --user start gammastep.service
