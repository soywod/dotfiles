#!/bin/bash

jackd -d alsa -d hw:PCH -n 2 &
alsa_in -j cloop -dcloop -q 1
