#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm compton

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/compton.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user start compton.service
