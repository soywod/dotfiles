#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

ln -sf $DIRNAME/toggle.sh ~/.local/bin/dotfiles--toggle-bluetooth
