#!/bin/bash

filename="mails-$(date +"%d").tar.gz"
file="/var/backups/$filename"

if [ -f "/var/backups/$filename" ]; then
  exit 0
fi

port=60022
host="pi@$(dig +short mail.soywod.me)"
tar="sudo tar -czf $file -C /var/mail/virtual/mail Maildir"

ssh -p $port $host $tar
scp -P $port $host:$file /var/backups/
