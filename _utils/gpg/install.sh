#!/bin/sh

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.gnupg
ln -sf $DIRNAME/config.cfg ~/.gnupg/gpg-agent.conf
