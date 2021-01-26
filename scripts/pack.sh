#!/bin/bash

if [ $# -eq 1 ]; then
  if [ -d "$1" ]; then
    TAR_PATH="`pwd`/`basename "$1"`.tar"

    tar cf $TAR_PATH -C "$1" .
    gzip -f9 $TAR_PATH
  else
    gzip -kf9 $1
  fi
fi

if [ $# -gt 1 ]; then
  TAR_PATH="`pwd`/archive.tar"

  tar cf $TAR_PATH $@
  gzip -f9 $TAR_PATH
fi
