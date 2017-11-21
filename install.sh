#!/bin/bash

mkdir -p ~/.config/nvim
mkdir -p ~/.config/fish/functions

if [ ! -d ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --bin
fi

if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
  ln -s $(realpath ~)/.bash-git-prompt/gitprompt.fish ~/.config/fish/config.fish
fi

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl \
    -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sf $(pwd)/nvim/init.vim ~/.config/nvim/init.vim
ln -sf -T $(pwd)/nvim/snips ~/.config/nvim/snips
ln -sf -T $(pwd)/i3 ~/.i3
ln -sf -T $(pwd)/fish/functions ~/.config/fish/functions

nvim +PlugInstall +qa
