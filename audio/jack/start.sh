#!/bin/bash

jackd -d alsa -d hw:PCH -n 2 &

sleep 2

/usr/bin/alsa_out -j ploop -dploop -q 1 2>&1 1> /dev/null &
/usr/bin/alsa_in  -j cloop -dcloop -q 1 2>&1 1> /dev/null
