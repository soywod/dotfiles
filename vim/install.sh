#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"
VIMPATH=/opt/vim

# --------------------------------------------------------------------- # Deps #

sudo pacman -S --needed --noconfirm curl gcc git lua make python3

# -------------------------------------------------------------------- # Build #

if [ ! -d $VIMPATH ]; then
	sudo git clone https://github.com/vim/vim.git $VIMPATH
	sudo chown -R $USER:$USER $VIMPATH
	cd $VIMPATH
else
	cd $VIMPATH
	git pull
	git checkout 03998f6 # v8.0.1850
fi

./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-python3interp=yes \
	--enable-luainterp=yes \
	--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
	--prefix=/usr/local

make VIMRUNTIMEDIR=/usr/local/share/vim/vim80
sudo make install

# ----------------------------------------------------------- # Plugin manager #

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl \
    -fLo ~/.vim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# -------------------------------------------------------------------- # Links #

ln -sf $DIRNAME/.vimrc ~
sudo ln -sf $DIRNAME/editor.sh /etc/profile.d
vim +PlugUpdate +qa

