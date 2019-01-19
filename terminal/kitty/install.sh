#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm kitty

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/kitty
ln -sf $DIRNAME/kitty.conf ~/.config/kitty/
