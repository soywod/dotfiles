#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

echo "Installing pacman packages…"
find "$DIRNAME" -name deps.txt -exec cat {} \; | sudo pacman -S --needed --noconfirm -

echo "Installing AUR packages…"
for pkg in $(find "$DIRNAME" -name deps-aur.txt -exec cat {} \;); do
  if [ -d "/opt/$pkg" ]; then
    echo "Updating $pkg…"
    cd "/opt/$pkg"
    git pull > /dev/null
  else
    echo "Installing $pkg…"
    sudo mkdir "/opt/$pkg"
    sudo chown -R $USER:$USER "/opt/$pkg"
    git clone --quiet https://aur.archlinux.org/$pkg.git "/opt/$pkg" > /dev/null
    cd "/opt/$pkg"
  fi

  makepkg --needed --noconfirm --noprogressbar -isc > /dev/null
done

echo "Installing dotfiles packages…"
find "$DIRNAME" -name install.sh ! -path "$DIRNAME/install.sh" -exec bash {} \;
