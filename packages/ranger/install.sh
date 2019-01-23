#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/ranger
ln -sf $DIRNAME/rc.conf ~/.config/ranger/
