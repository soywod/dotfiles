#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/gammastep
ln -sf $DIRNAME/config.ini ~/.config/gammastep/config.ini

mkdir -p ~/.config/systemd/user
cp $DIRNAME/service.ini ~/.config/systemd/user/gammastep.service

systemctl --user daemon-reload
systemctl --user enable gammastep.service
systemctl --user start gammastep.service
