#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm alsa-plugins alsa-utils

# -------------------------------------------------------------------- # Links #

sudo usermod -a -G audio $USER

ln -sf $DIRNAME/config $HOME/.asoundrc

