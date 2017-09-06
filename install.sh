#!/bin/bash

mkdir -p ~/.config/nvim/snips

if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
fi

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
  curl \
    -fLo ~/.config/nvim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -f -s $(pwd)/nvim/init.vim ~/.config/nvim/init.vim
ln -f -s $(pwd)/nvim/snips ~/.config/nvim/snips

nvim +PlugInstall +qa

