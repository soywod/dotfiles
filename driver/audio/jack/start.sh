#!/bin/bash

old_card=

while sleep 2; do
  [[ -d /proc/asound/USB ]] && new_card=usb || new_card=pch
  [[ "$old_card" == "$new_card" ]] && continue

  systemctl --user stop jack@${old_card:-pch}
  systemctl --user start jack@$new_card

  old_card=$new_card
done
