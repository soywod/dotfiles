#!/bin/sh

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mkdir -p ~/.gnupg
ln -sf $DIRNAME/config ~/.gnupg/gpg-agent.conf
