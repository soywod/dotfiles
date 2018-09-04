#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm feh i3-gaps i3lock scrot xclip

# --------------------------------------------------------------------- # Link #

mkdir -p $HOME/.i3

ln -sf $DIRNAME/config $HOME/.i3/
