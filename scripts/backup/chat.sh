#!/bin/bash

dirname="/var/backups/chat"
filename="$(date +"%d").tar.gz"
file="$dirname/$filename"

if [ -f "$file" ]; then
  exit 0
fi

host="pi@$(dig +short mail.soywod.me)"
tar="sudo tar -czf $file -C /var/lib prosody"

ssh $host $tar
scp $host:$file $dirname
