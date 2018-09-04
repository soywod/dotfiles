#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm neovim python python-neovim

# ----------------------------------------------------------- # Plugin manager #

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl \
    -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# -------------------------------------------------------------------- # Links #

mkdir -p ~/.config/nvim

ln -sf $DIRNAME/init.vim ~/.config/nvim/
sudo ln -sf $DIRNAME/editor.sh /etc/profile.d

nvim +PlugInstall +qa
