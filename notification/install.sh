#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm libnotify dunst

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/dunst
ln -sf $DIRNAME/dunst.conf ~/.config/dunst/dunstrc
ln -sf $DIRNAME/notify.* ~/.config/dunst/

