#!/bin/bash

DIRNAME="$(cd "$(dirname "$0")";pwd -P)"

$DIRNAME/build.sh
$DIRNAME/link.sh
