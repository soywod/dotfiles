#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm mpd

# -------------------------------------------------------------------- # Links #

mkdir -p /run/user/$UID/mpd
mkdir -p $HOME/.config/mpd/playlist

cp config.tpl config.out
sed -i s/\$UID/$UID/g config.out

ln -sf $DIRNAME/config.out $HOME/.config/mpd/mpd.conf

systemctl --user enable mpd
systemctl --user start  mpd

