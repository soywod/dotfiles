#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm i3-gaps i3lock scrot xclip

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.i3

ln -sf $DIRNAME/config ~/.i3/
