#!/bin/bash

sleep 2
jack_connect cloop:capture_1 system:playback_1
jack_connect cloop:capture_2 system:playback_2
