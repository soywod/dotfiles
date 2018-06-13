#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# ---------------------------------------------------------- # Git bash prompt #

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
fi

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/.bash_aliases ~
ln -sf $DIRNAME/.bash_profile ~
ln -sf $DIRNAME/.bashrc ~

