#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

# sudo pacman -S --needed --noconfirm curl gcc git make python3

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/.bash_aliases ~
ln -sf $DIRNAME/.bash_profile ~
ln -sf $DIRNAME/.bashrc ~

