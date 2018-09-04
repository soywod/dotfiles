#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm transmission-cli

# --------------------------------------------------------------------- # Link #

mkdir -p $HOME/.config/transmission

cp $DIRNAME/settings.tpl.json $DIRNAME/settings.json
sed -i s/\$USER/$USER/g $DIRNAME/settings.json

ln -sf $DIRNAME/settings.json $HOME/.config/transmission/
