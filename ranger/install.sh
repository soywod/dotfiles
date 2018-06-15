#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm ranger w3m

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.config/ranger
ln -sf $DIRNAME/config $HOME/.config/ranger/rc.conf

