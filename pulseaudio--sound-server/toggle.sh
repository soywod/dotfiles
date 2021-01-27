#!/bin/bash

if amixer -c 0 get Master | grep -q "\[on\]"
then
  amixer set Master mute &>/dev/null
else
  amixer set Master unmute &>/dev/null
  amixer set Headphone unmute &>/dev/null
  amixer set Speaker unmute &>/dev/null
fi
