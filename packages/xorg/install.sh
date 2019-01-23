#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

ln -sf $DIRNAME/xinitrc ~/.xinitrc
ln -sf $DIRNAME/xserverrc ~/.xserverrc
