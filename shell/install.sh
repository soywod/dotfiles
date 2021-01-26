#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
else
  cd ~/.bash-git-prompt
  git pull
fi

ln -sf "$DIRNAME/aliases" ~/.bash_aliases
ln -sf "$DIRNAME/completion" ~/.bash_completion
ln -sf "$DIRNAME/config" ~/.bashrc
ln -sf "$DIRNAME/config" ~/.bash_profile
