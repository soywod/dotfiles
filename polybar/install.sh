#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# -------------------------------------------------------------------- # Build #

sudo pacman -S --needed --noconfirm libmpdclient
git clone https://aur.archlinux.org/polybar.git /tmp/polybar
cd /tmp/polybar && makepkg --needed --noconfirm -isc

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.config/polybar
ln -sf $DIRNAME/config $HOME/.config/polybar

