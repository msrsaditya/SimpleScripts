#!/bin/sh

notify-send "Wi-Fi Connection 🔎" "Searching for Available Networks.."

bssid=$(nmcli device wifi list | sed '1d' |bemenu -p "" --margin 100| cut -c 9- | cut -d ' ' -f1)

password=$(echo "" |bemenu -p " Password:")

nmcli device wifi connect "$bssid" password "$password"

if [ $? -eq 0 ]; then
	pkill dunst; notify-send "Wi-Fi Connection ✅" "Successfully connected to $bssid"
else
	pkill dunst; notify-send "Wi-Fi Connection ❌" "Failed to connect to $bssid"
fi
