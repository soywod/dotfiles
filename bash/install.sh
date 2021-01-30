#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

if [ -d ~/.bash-git-prompt ]; then
  cd ~/.bash-git-prompt
  git pull
else
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
fi

ln -sf "$DIRNAME/aliases.sh" ~/.bash_aliases
ln -sf "$DIRNAME/completion.sh" ~/.bash_completion
ln -sf "$DIRNAME/config.sh" ~/.bashrc
ln -sf "$DIRNAME/profile.sh" ~/.profile
