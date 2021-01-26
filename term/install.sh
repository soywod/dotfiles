#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/kitty
ln -sf "$DIRNAME/config" ~/.config/kitty/kitty.conf
