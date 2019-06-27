#!/bin/bash

media=$1
mode=$2

if [ $media == 'png' ]; then
  file=/tmp/screenshot.png
  rm -f $file

  if [ $mode == 'selection' ]; then
    selection=`xrectsel`
    ffcast -q -g $selection png $file
    xclip -selection clipboard -t image/png -i $file
  elif [ $mode == 'window' ]; then
    ffcast -q -w png $file
    xclip -selection clipboard -t image/png -i $file
  fi
elif [ $media == 'mp4' ]; then
  if [ -z `pgrep -f ffcast` ]; then
    file=/tmp/record.mp4
    rm -f $file

    if [ $mode == 'selection' ]; then
      selection=`xrectsel`
      ffcast -q -g $selection rec $file &
    elif [ $mode == 'window' ]; then
      ffcast -q -w rec $file &
    fi
  else
    pkill ffmpeg
  fi
fi
