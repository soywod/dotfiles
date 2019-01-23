#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/dunst
mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/dunstrc ~/.config/dunst/
ln -sf $DIRNAME/notify.* ~/.config/dunst/
ln -sf $DIRNAME/dunst.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user start dunst.service
