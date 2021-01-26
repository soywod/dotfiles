#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl \
    -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

mkdir -p ~/.config/nvim/backup
mkdir -p ~/.config/nvim/swap
mkdir -p ~/.config/nvim/undo

ln -sf $DIRNAME/config ~/.config/nvim/init.vim
ln -sfn $DIRNAME/snippets ~/.config/nvim/UltiSnips
sudo ln -sf $DIRNAME/editor.sh /etc/profile.d

nvim +PlugInstall +qa
