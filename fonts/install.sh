#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.local/share/fonts
cp $DIRNAME/*.ttf $DIRNAME/*.otf ~/.local/share/fonts
fc-cache
