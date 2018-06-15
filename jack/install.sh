#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm jack

