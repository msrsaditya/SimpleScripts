#!/bin/sh

filename="$1"
upload_url=$(curl -F "file=@$filename" https://0x0.st)
echo -n "$upload_url" | wl-copy
notify-send "URL Copied" "URL: $upload_url"
