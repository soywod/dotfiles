#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# ---------------------------------------------------------- # Git bash prompt #

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
else
  cd ~/.bash-git-prompt
  git pull
fi

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/alias ~/.bash_aliases
ln -sf $DIRNAME/config ~/.bashrc

