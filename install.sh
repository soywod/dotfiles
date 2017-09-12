#!/bin/bash

mkdir -p ~/.vim
mkdir -p ~/.config/fish/functions

if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --bin
fi

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
  ln -s $(realpath ~)/.bash-git-prompt/gitprompt.fish ~/.config/fish/config.fish
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
ln -sf -T $(pwd)/fish/functions ~/.config/fish/functions

vim +PlugInstall +qa

~/.vim/plugged/YouCompleteMe/install.py

