#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/sway
ln -sf "$DIRNAME/config.cfg" ~/.config/sway/config
