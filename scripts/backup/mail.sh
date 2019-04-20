#!/bin/bash

dirname="/var/backups/mail"
filename="$(date +"%d").tar.gz"
file="$dirname/$filename"

if [ -f "$file" ]; then
  exit 0
fi

host="alarm@$(dig +short mail.soywod.me)"
tar="sudo tar -czf $file -C /var/mail/virtual/mail Maildir"

ssh $host $tar
scp $host:$file $dirname
