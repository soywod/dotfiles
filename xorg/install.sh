#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm xorg xorg-xinit

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/xinit $HOME/.xinitrc
ln -sf $DIRNAME/xserver $HOME/.xserverrc

