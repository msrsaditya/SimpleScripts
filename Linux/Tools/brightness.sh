#!/bin/sh

# Get the current brightness level (adjust the command if needed)
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

# Get the maximum brightness level (adjust the command if needed)
max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

# Calculate the percentage of brightness
brightness_percentage=$((brightness * 100 / max_brightness))

# Send the notification with the progress bar to dunst
dunstify -r 9999 -i display-brightness-symbolic \
    "Brightness $brightness_percentage%" \
    -h int:value:$brightness_percentage -h int:max:100 -h string:x-dunst-stack-tag:brightness
