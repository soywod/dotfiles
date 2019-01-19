#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm i3-gaps i3lock scrot xclip

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/i3

ln -sfT $DIRNAME/config ~/.config/i3/config
