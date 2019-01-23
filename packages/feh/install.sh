#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/feh.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable feh.service
systemctl --user start feh.service
