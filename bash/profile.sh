# Enables Wayland support for Firefox and Thunderbird
export MOZ_ENABLE_WAYLAND=1

# Starts Sway only for TTY1
if [ "$(tty)" == "/dev/tty1" ]
then
  systemctl --user import-environment
  exec systemctl --wait --user start sway.service
fi

if [ -e /home/soywod/.nix-profile/etc/profile.d/nix.sh ]; then . /home/soywod/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
