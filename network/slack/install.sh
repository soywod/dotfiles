#!/bin/bash

if [ ! -d /tmp/light ]; then
  git clone https://aur.archlinux.org/slack-desktop.git /tmp/slack
fi

cd /tmp/slack && makepkg --noconfirm -isc
