#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/transmission

cp $DIRNAME/settings.tpl.json $DIRNAME/settings.json
sed -i s/\$USER/$USER/g $DIRNAME/settings.json

ln -sf $DIRNAME/settings.json ~/.config/transmission/
