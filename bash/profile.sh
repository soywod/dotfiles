# Nix shell
# if [ -e /home/soywod/.nix-profile/etc/profile.d/nix.sh ]; then
#   source /home/soywod/.nix-profile/etc/profile.d/nix.sh
# fi

# Sway
systemctl --user import-environment
systemctl --user start sway-session.target
exec systemctl --wait --user start sway.service

# if [ -z $DISPLAY ] && [ "$(tty)" == "/dev/tty1" ]; then
  # exec "systemctl --user import-environment; systemctl --user start sway-session.target"
  # exec sway
# fi
