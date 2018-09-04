#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm alsa-utils

# --------------------------------------------------------------------- # Link #

echo snd-aloop | sudo tee /etc/modules-load.d/snd-aloop.conf >/dev/null
sudo usermod -a -G audio $USER

ln -sf $DIRNAME/asoundrc $HOME/.asoundrc
