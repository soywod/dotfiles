#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm alsa alsa-plugins alsa-utils jack

# -------------------------------------------------------------------- # Links #

sudo usermod -a -G audio $USER
ln -sf $DIRNAME/.asoundrc $HOME

