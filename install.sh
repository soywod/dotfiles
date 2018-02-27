#!/bin/bash

sudo apt install -y xbacklight xclip scrot

mkdir -p ~/.config/nvim

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
fi

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl \
    -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sf $PWD/nvim/init.vim ~/.config/nvim/init.vim
ln -sf $PWD/i3 ~/.i3

nvim +PlugInstall +qa

