#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

sudo ln -sf "$DIRNAME/capture-screen.sh" /usr/local/bin/dotfiles--capture-screen
sudo ln -sf "$DIRNAME/capture-selection.sh" /usr/local/bin/dotfiles--capture-selection
sudo ln -sf "$DIRNAME/record-selection.sh" /usr/local/bin/dotfiles--record-selection
