#!/bin/sh

token=$(cat "${HOME}/.github.token")
count=$(curl -u soywod:${token} https://api.github.com/notifications | jq '. | length')

if [[ "$count" != "0" ]]; then
  echo '{"text":'$count'}'
fi
