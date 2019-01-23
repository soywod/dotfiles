#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

echo snd-aloop | sudo tee /etc/modules-load.d/snd-aloop.conf >/dev/null
sudo usermod -a -G audio $USER

ln -sf $DIRNAME/asoundrc ~/.asoundrc
