#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/waybar
ln -sf "$DIRNAME/config.json" ~/.config/waybar/config
ln -sf "$DIRNAME/style.css" ~/.config/waybar/style.css
