#!/bin/bash

mkdir -p ~/.vim

if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl \
    -fLo ~/.vim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sf $(pwd)/vim/vimrc ~/.vimrc
ln -sf -T $(pwd)/vim/snips ~/.vim/snips
ln -sf -T $(pwd)/i3 ~/.i3

vim +PlugInstall +qa

~/.vim/plugged/YouCompleteMe/install.py

