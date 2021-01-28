#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

# Install pacman deps
find "$DIRNAME" -name deps.txt -exec cat {} \; | sudo pacman -S --needed --noconfirm -

# Install AUR deps
for pkg in $(find "$DIRNAME" -name deps-aur.txt -exec cat {} \;); do
  if [ -d "/opt/$pkg" ]; then
    cd "/opt/$pkg"
    git pull origin master
  else
    sudo mkdir "/opt/$pkg"
    sudo chown -R $USER:$USER "/opt/$pkg"
    git clone https://aur.archlinux.org/$pkg.git "/opt/$pkg"
    cd "/opt/$pkg"
  fi

  makepkg --needed --noconfirm -isc
done

# Install dotfiles packages
find "$DIRNAME" -name install.sh ! -path "$DIRNAME/install.sh" -exec bash {} \;
