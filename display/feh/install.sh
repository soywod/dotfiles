#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm feh

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/feh.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user start feh.service
