#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm feh i3-gaps scrot xclip

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.i3
ln -sf $DIRNAME/config $HOME/.i3

