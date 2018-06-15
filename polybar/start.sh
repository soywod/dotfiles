#!/bin/bash

killall -q -9 polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar top &
polybar bottom &

