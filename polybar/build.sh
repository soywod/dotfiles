#!/bin/bash

if [ ! -d /tmp/polybar ]; then
  git clone https://aur.archlinux.org/polybar.git /tmp/polybar
fi

cd /tmp/polybar && makepkg --noconfirm -isc

