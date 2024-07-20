#!/bin/sh

bluetoothctl power on # Turn On Bluetooth
notify-send "📶 Bluetooth Device Search" "Scanning for Bluetooth devices 🔎"

bluetoothctl scan on & # Scan For 10 Seconds and then Turn Off Scanning.
sleep 10
bluetoothctl scan off

# List Available Devices in Bemenu, Connect to the Selected Device Using it's Mac Address.
bluetoothctl connect "$(bluetoothctl devices | cut -c 8- | bemenu -p "" | cut -d' ' -f1)"
