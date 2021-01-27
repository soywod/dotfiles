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
      git clone https://aur.archlinux.org/$package.git /opt/$package
    fi

    cd /opt/$package
    git pull origin master
    makepkg --needed --noconfirm -isc
  done
}

install_packages \
  bash-completion \
  bluez \
  bluez-utils \
  celt \
  chromium \
  docker \
  docker-compose \
  feh \
  ffado \
  filezilla \
  fzf \
  ghostscript \
  imagemagick \
  kitty \
  libmpdclient \
  libnotify \
  mpc \
  mpd \
  mpv \
  neovim \
  networkmanager \
  pulseaudio \
  python \
  python-neovim \
  ripgrep \
  scrot \
  thunderbird \
  w3m \
  xclip \
  xdotool \

install_aur_packages \
  light \
  slack-desktop \
  telegram-desktop \
  xrectsel ffcast \
  android-sdk \
  libreoffice-still \
  postman-bin \
  # jdk8 \

find "$DIRNAME/.." -name install.sh -exec bash {} \;
