#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

sudo ln -sf "$DIRNAME/toggle.sh" /usr/local/bin/dotfiles--toggle-bluetooth
