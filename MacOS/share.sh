#!/bin/bash

# A Simple Script to Share Any File Online

filename="$1"
url=$(curl --silent --form "file=@$filename" https://0x0.st)
printf "%s" "$url" | pbcopy
osascript -e "display notification \"URL: $url\" with title \"URL Copied\""
