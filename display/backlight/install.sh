#!/bin/bash

if [ ! -d /tmp/light ]; then
  git clone https://aur.archlinux.org/light.git /tmp/light
fi

cd /tmp/light && makepkg --noconfirm -isc
