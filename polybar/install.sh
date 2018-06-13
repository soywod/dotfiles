#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# -------------------------------------------------------------------- # Build #

# sudo pacman -S --needed --noconfirm feh i3-gaps scrot xclip

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.config/polybar
ln -sf $DIRNAME/config $HOME/.config/polybar

