#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm networkmanager

# -------------------------------------------------------------------- # Links #

sudo systemctl enable NetworkManager
sudo systemctl start  NetworkManager

