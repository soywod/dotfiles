#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/mako
ln -sf $DIRNAME/config.cfg ~/.config/mako/config

mkdir -p ~/.config/systemd/user
cp $DIRNAME/service.ini ~/.config/systemd/user/mako.service

systemctl --user daemon-reload
systemctl --user enable mako.service
systemctl --user start mako.service
