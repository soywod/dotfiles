#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# --------------------------------------------------------------- # Dependency #

sudo pacman -S --needed --noconfirm neovim python python-neovim

# ----------------------------------------------------------- # Plugin manager #

if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  curl \
    -fLo ~/.local/share/nvim/site/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# --------------------------------------------------------------------- # Link #

mkdir -p ~/.config/nvim/backup
mkdir -p ~/.config/nvim/swap
mkdir -p ~/.config/nvim/undo

ln -sf $DIRNAME/init.vim ~/.config/nvim/
ln -sfn $DIRNAME/snippets ~/.config/nvim/UltiSnips
sudo ln -sf $DIRNAME/editor.sh /etc/profile.d

nvim +PlugInstall +qa
