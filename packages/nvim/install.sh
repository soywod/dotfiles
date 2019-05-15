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

ln -sf $DIRNAME/init.vim ~/.config/nvim/
ln -sfn $DIRNAME/snippets ~/.config/nvim/UltiSnips
ln -sfn $DIRNAME/snippets/typescript.snippets ~/.config/nvim/UltiSnips/javascript.snippets
sudo ln -sf $DIRNAME/editor.sh /etc/profile.d

nvim +PlugInstall +qa
