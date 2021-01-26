#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/polybar
mkdir -p ~/.config/systemd/user

cp $DIRNAME/config ~/.config/polybar/config
sed -i s/\$UID/$UID/g ~/.config/polybar/config
ln -sf $DIRNAME/service ~/.config/systemd/user/polybar.service

systemctl --user daemon-reload
systemctl --user start polybar.service
