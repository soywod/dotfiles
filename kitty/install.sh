#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/kitty
ln -sf "$DIRNAME/config.cfg" ~/.config/kitty/kitty.conf
