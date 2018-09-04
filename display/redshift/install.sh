#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm redshift

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/systemd/user

ln -sf $DIRNAME/redshift.service ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user start redshift.service
