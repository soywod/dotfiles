#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/mpd/playlist

cp $DIRNAME/config ~/.config/mpd/mpd.conf
sed -i s/\$UID/$UID/g ~/.config/mpd/mpd.conf

systemctl --user enable mpd
systemctl --user start  mpd
