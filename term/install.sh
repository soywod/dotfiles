#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm kitty

# --------------------------------------------------------------------- # Font #

cp $DIRNAME/*.ttf $DIRNAME/*.otf ~/.local/share/fonts
fc-cache

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/kitty.conf ~/.config/kitty

