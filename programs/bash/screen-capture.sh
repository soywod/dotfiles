#!/usr/bin/env bash

file="/tmp/screenshot.jpeg"
rm -f $file

grim -t jpeg -q 75 - > "$file"
wl-copy < "$file"
