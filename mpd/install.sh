#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm mpd

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.config/mpd/playlist

cp $DIRNAME/config.tpl $DIRNAME/config.out
sed -i s/\$UID/$UID/g $DIRNAME/config.out

ln -sf $DIRNAME/config.out $HOME/.config/mpd/mpd.conf

systemctl --user enable mpd
systemctl --user start  mpd

