#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"
VIMPATH=/opt/vim

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm fzf ripgrep

