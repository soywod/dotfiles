#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm transmission-cli

# -------------------------------------------------------------------- # Links #

mkdir -p $HOME/.config/transmission

cp $DIRNAME/config.tpl $DIRNAME/config.out
sed -i s/\$USER/$USER/g $DIRNAME/config.out

ln -sf $DIRNAME/config.out $HOME/.config/transmission/settings.json

