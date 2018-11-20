#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# ------------------------------------------------------------- # Dependencies #

sudo pacman -S --needed --noconfirm bash-completion

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
else
  cd ~/.bash-git-prompt
  git pull
fi

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/bash_aliases ~/.bash_aliases
ln -sf $DIRNAME/bash_completion ~/.bash_completion
ln -sf $DIRNAME/bashrc ~/.bashrc
ln -sf $DIRNAME/bashrc ~/.bash_profile
