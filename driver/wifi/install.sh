#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm networkmanager

# --------------------------------------------------------------------- # Link #

sudo systemctl enable NetworkManager
sudo systemctl start  NetworkManager
