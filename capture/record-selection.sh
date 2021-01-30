#!/bin/bash

if [ -z "$(pgrep -f wf-recorder)" ]; then
  file="/tmp/record.mp4"
  rm -f $file

  wf-recorder -g "$(slurp)" -f "$file"
else
  pkill -SIGINT wf-recorder
fi
