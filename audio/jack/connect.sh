#!/bin/bash

# give it some time before connecting to system ports
sleep 4

# cloop ports -> jack output ports 
jack_connect cloop:capture_1 system:playback_1
jack_connect cloop:capture_2 system:playback_2


# system microphone (RME analog input 3) to "ploop" ports  
jack_connect system:capture_1 ploop:playback_1
jack_connect system:capture_1 ploop:playback_2

# done
exit 0
