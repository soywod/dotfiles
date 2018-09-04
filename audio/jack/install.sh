#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm jack

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/jack@.service ~/.config/systemd/user/
ln -sf $DIRNAME/jack.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user start jack.service
