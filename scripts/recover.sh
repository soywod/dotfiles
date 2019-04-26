#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

function install_packages {
  sudo pacman -S --needed --noconfirm $@
}

function install_aur_packages {
  for package in "$@"
  do
    if [ ! -d /opt/$package ]; then
      sudo mkdir /opt/$package
      sudo chown -R $USER:$USER /opt/$package
      # git init && git remote add origin https://aur.archlinux.org/$package.git
      git clone https://aur.archlinux.org/$package.git /opt/$package
    fi

    cd /opt/$package
    git pull origin master
    makepkg --needed --noconfirm -isc
  done
}

install_packages \
  alsa-utils \
  bash-completion \
  bluez \
  bluez-utils \
  celt \
  chromium \
  compton \
  dmenu \
  docker \
  docker-compose \
  dunst \
  feh \
  ffado \
  filezilla \
  fzf \
  ghostscript \
  imagemagick \
  i3lock \
  i3-gaps \
  jack \
  kitty \
  libmpdclient \
  libnotify \
  mpc \
  mpd \
  mpv \
  neovim \
  networkmanager \
  python \
  python-neovim \
  ranger \
  redshift \
  ripgrep \
  scrot \
  sqlitebrowser \
  thunderbird \
  transmission-cli \
  w3m \
  xclip \
  xorg \
  xorg-xinit \
  p7zip \

install_aur_packages \
  light \
  polybar \
  slack-desktop \
  xrectsel ffcast \
  jdk9 \
  openoffice \
  signal \

find "$DIRNAME/../packages" -name install.sh -exec bash {} \;
