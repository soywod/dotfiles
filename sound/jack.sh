#!/bin/bash

card=

function usePCH {
  jackd -d alsa -d hw:PCH -r 48000 -n 2 -p 256
}

function useUSB {
  jackd -d alsa -d hw:USB -r 48000 -n 3 -p 64
}

while sleep 1; do
  [[ -d /proc/asound/USB ]] && newcard=USB || newcard=PCH
  [[ $card == $newcard ]] && continue

  killall -9 jackd
  sleep 2
  card=$newcard
  use$card &
done

