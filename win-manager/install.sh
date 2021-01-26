#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/i3
ln -sf "$DIRNAME/config" ~/.config/i3/
