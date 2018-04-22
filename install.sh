#!/bin/bash

DIRNAME=$PWD

# Install deps
sudo apt install -y git curl i3 xbacklight xclip scrot

# Build vim from sources
if [ ! -d /opt/vim ]; then
	sudo git clone https://github.com/vim/vim.git /opt/vim
	sudo chown -R $USER:$USER /opt/vim
	cd /opt/vim
else
	cd /opt/vim
	git pull
fi

./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-python3interp=yes \
	--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
	--prefix=/usr/local

make VIMRUNTIMEDIR=/usr/local/share/vim/vim80

sudo make install
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim

# Install git bash prompt
if [ ! -d ~/.bash-git-prompt ]; then
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
fi

# Install plugin manager
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl \
    -fLo ~/.vim/autoload/plug.vim \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Link configuration
ln -sf $DIRNAME/vim/vimrc ~/.vimrc
ln -Tsf $DIRNAME/i3 ~/.i3

# Install plugins
vim +PlugUpdate +qa

