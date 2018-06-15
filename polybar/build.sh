#!/bin/bash

sudo pacman -S --needed --noconfirm libmpdclient

if [ ! -d /tmp/polybar ]; then
  git clone https://aur.archlinux.org/polybar.git /tmp/polybar
fi

cd /tmp/polybar && makepkg --needed --noconfirm -isc

