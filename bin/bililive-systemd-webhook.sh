#!/bin/bash

HOOK_DIR="bililive-systemd-webhook/hooks/"
if [ -n "$XDG_CONFIG_HOME" ]; then
    HOOK_PATH="$XDG_CONFIG_HOME/$HOOK_DIR"
else
    HOOK_PATH="$HOME/.config/$HOOK_DIR"
fi

content_length=0
while :;  do
    IFS=$'\r' read -r line <&3
    [[ -z "$line" ]] && break
    if [[ $(echo "$line" | cut -d ':' -f 1 | tr '[:upper:]' '[:lower:]') = "content-length" ]]; then
        content_length=$(echo "$line" | cut -d ':' -f 2 | xargs)
    fi
done
content=$(dd status=none bs=1 count="$content_length" <&3)
echo -en 'HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Length: 0\r\n\r\n' >&3
exec 3<&-

read -r event_type room_id name < <(echo "$content" | jq -cr '.EventType, .EventData.RoomId, .EventData.Name' | xargs)
title=$(echo "$content" | jq -cr '.EventData.Title')

while read -r file; do
    if [ -n "$file" ]; then
      sh "$file" "$event_type" "$name" "$title" "$room_id" "$content"
    fi
done < <(find -L "$HOOK_PATH" -maxdepth 1 -type f -print | sort ;
         [[ -d "$HOOK_PATH$event_type" ]] && find -L "$HOOK_PATH$event_type" -maxdepth 1 -type f -print | sort)

