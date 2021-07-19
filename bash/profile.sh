# Start Sway only for TTY1
if [ "$(tty)" == "/dev/tty1" ]; then
  systemctl --user import-environment
  exec systemctl --wait --user start sway.service
fi
