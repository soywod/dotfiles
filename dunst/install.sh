#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm libnotify dunst

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/dunst
ln -sf $DIRNAME/config ~/.config/dunst/dunstrc

