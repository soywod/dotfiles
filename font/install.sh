#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# ------------------------------------------------------------------ # Install #

cp $DIRNAME/*.ttf $DIRNAME/*.otf ~/.local/share/fonts
fc-cache

