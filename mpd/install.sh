#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm mpd

# -------------------------------------------------------------------- # Links #

sudo mkdir -p /run/mpd
sudo chown $USER:$USER /run/mpd

mkdir -p $HOME/.config/mpd/playlist

ln -sf $DIRNAME/config $HOME/.config/mpd/mpd.conf

systemctl --user enable mpd
systemctl --user start  mpd

