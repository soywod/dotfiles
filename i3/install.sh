#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm i3-gaps feh scrot

# -------------------------------------------------------------------- # Links #

mkdir -p ~/.i3
ln -sf $DIRNAME/config ~/.i3
ln -sf $DIRNAME/status ~/.i3

