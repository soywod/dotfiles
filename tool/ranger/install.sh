#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm ranger w3m

# --------------------------------------------------------------------- # Link #

mkdir -p $HOME/.config/ranger
ln -sf $DIRNAME/rc.conf $HOME/.config/ranger/
