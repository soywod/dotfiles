#!/bin/bash

# https://dev.to/mafflerbach/use-pass-and-rofi-to-get-a-fancy-password-manager-2k37

shopt -s nullglob globstar

passwd_store_dir="${HOME}/Dropbox/password-store"

passwd_files=("$passwd_store_dir"/**/*.gpg)
passwd_files=("${passwd_files[@]#"$passwd_store_dir"/}")
passwd_files=("${passwd_files[@]%.gpg}")

passwd=$(printf "%s\n" "${passwd_files[@]}" | rofi -dmenu "$@")

pass show $passwd
