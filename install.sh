#!/bin/bash

mkdir -p ~/.config/nvim

if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

if [ ! -f ~/.config/nvim/autoload/plug.vim ]; then
  curl \
    -fLo ~/.config/nvim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sf $(pwd)/nvim/init.vim ~/.config/nvim/init.vim
ln -sf -T $(pwd)/nvim/snips ~/.config/nvim/snips
ln -sf -T $(pwd)/i3 ~/.i3

nvim +PlugInstall +qa

