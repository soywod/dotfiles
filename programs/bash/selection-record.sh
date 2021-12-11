#!/usr/bin/env bash

if [ -z "$(pgrep -f wf-recorder)" ]; then
  file="/tmp/record.mp4"
  rm -f $file

  geom="$(slurp)"
  if [ -z "$geom" ]; then
    exit
  fi
  wf-recorder -g "$geom" -f "$file"
else
  pkill -SIGINT wf-recorder
fi
