#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm xorg xorg-xinit

# --------------------------------------------------------------------- # Link #

ln -sf $DIRNAME/xinitrc $HOME/.xinitrc
ln -sf $DIRNAME/xserverrc $HOME/.xserverrc
