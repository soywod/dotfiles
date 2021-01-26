#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.config/systemd/user
ln -sf $DIRNAME/service ~/.config/systemd/user/redshift.service

systemctl --user daemon-reload
systemctl --user start redshift.service
