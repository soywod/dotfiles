#!/bin/bash

service_status="$(sudo systemctl is-active bluetooth)"

enable_bluetooth() {
  sudo systemctl start bluetooth
  bluetoothctl power on
}

disable_bluetooth() {
  bluetoothctl power off
  sudo systemctl stop bluetooth
}

if [ "$1" == "on" ]; then
  if [ "$service_status" == "inactive" ]; then
    enable_bluetooth
  fi
  exit 0
fi

if [ "$1" == "off" ]; then
  if [ "$service_status" == "active" ]; then
    disable_bluetooth
  fi
  exit 0
fi

if [ "$service_status" == "active" ]; then
  disable_bluetooth
else
  enable_bluetooth
fi
