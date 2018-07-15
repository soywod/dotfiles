#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

mpv $DIRNAME/notify.opus >/dev/null 2>&1 & disown

