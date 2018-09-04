#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p $HOME/.config/polybar

cp $DIRNAME/config.tpl $DIRNAME/config
sed -i s/\$UID/$UID/g $DIRNAME/config

ln -sf $DIRNAME/config $HOME/.config/polybar/
