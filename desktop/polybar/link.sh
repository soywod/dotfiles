#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/polybar
mkdir -p ~/.config/systemd/user

cp $DIRNAME/config.tpl $DIRNAME/config
sed -i s/\$UID/$UID/g $DIRNAME/config

ln -sf $DIRNAME/config ~/.config/polybar/
ln -sf $DIRNAME/polybar.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable polybar.service
systemctl --user start polybar.service
