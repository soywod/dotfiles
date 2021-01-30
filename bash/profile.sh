# Nix shell
if [ -e /home/soywod/.nix-profile/etc/profile.d/nix.sh ]; then
  source /home/soywod/.nix-profile/etc/profile.d/nix.sh
fi

# Sway
if [ -z $DISPLAY ] && [ "$(tty)" == "/dev/tty1" ]; then
  exec sway
fi
