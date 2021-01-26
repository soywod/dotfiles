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
  bash-completion \
  bluez \
  bluez-utils \
  celt \
  chromium \
  compton \
  docker \
  docker-compose \
  dunst \
  feh \
  ffado \
  filezilla \
  fzf \
  ghostscript \
  i3-gaps \
  i3lock \
  imagemagick \
  kitty \
  libmpdclient \
  libnotify \
  mpc \
  mpd \
  mpv \
  neovim \
  networkmanager \
  p7zip \
  pulseaudio \
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
  xdotool \
  xorg \
  xorg-xinit \

install_aur_packages \
  light \
  polybar \
  slack-desktop \
  telegram-desktop \
  xrectsel ffcast \
  android-sdk \
  libreoffice-still \
  postman-bin \
  # jdk8 \

find "$DIRNAME/.." -name install.sh -exec bash {} \;
