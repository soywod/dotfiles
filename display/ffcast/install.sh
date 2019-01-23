#!/bin/bash

if [ ! -d /tmp/xrectsel ]; then
  git clone https://aur.archlinux.org/xrectsel.git /tmp/xrectsel
fi

cd /tmp/xrectsel && makepkg --noconfirm -isc

if [ ! -d /tmp/ffcast ]; then
  git clone https://aur.archlinux.org/ffcast.git /tmp/ffcast
fi

cd /tmp/ffcast && makepkg --noconfirm -isc
