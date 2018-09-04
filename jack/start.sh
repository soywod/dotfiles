#!/bin/bash

function usePCH {
  jackd -d alsa -d hw:PCH -n 2 &
}

function useUSB {
  jackd -d alsa -d hw:USB -n 3 -p 256 &
}

card=

while sleep 1; do
  [[ -d /proc/asound/USB ]] && newcard=USB || newcard=PCH
  [[ $card == $newcard ]] && continue

  card=$newcard

  killall -q -9 jackd
  while pgrep -u $UID -x jackd >/dev/null; do sleep 1; done

  use$card
  alsa_in -j cloop -dcloop -q 1 &

  sleep 2
  jack_connect cloop:capture_1 system:playback_1
  jack_connect cloop:capture_2 system:playback_2
done

