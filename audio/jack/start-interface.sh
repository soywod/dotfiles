#!/bin/bash

if [ "$1" == 'usb' ]; then
  jackd -d alsa -d hw:USB -n 3 -p 256 &
else
  jackd -d alsa -d hw:PCH -n 2 &
fi

alsa_in -j cloop -dcloop -q 1
