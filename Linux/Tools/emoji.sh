#!/bin/sh

# BEMENU Prompt for Selecting an Emoji From Emoji File
selected_line=$(cat /usr/local/bin/Scripts/Tools/emoji | bemenu -p "")

# Extract the Selected Emoji Leaving Description Aside.
selected_emoji=$(echo "$selected_line" | awk '{print $1}')

# Copy Selected Emoji to Clipboard
echo -n "$selected_emoji" | wl-copy
