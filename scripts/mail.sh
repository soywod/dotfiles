#!/bin/bash

sudo systemctl start mail-tunnel

thunderbird >/dev/null 2>&1 &
disown
