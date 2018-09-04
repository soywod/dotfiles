#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm dunst libnotify mpv

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/dunst

ln -sf $DIRNAME/dunstrc ~/.config/dunst/
ln -sf $DIRNAME/notify.* ~/.config/dunst/
