#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p $HOME/.config/polybar

cp $DIRNAME/config.tpl $DIRNAME/config.out
sed -i s/\$UID/$UID/g $DIRNAME/config.out

ln -sf $DIRNAME/config.out $HOME/.config/polybar/config

