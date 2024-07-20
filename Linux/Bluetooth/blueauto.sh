#!/bin/sh
bluetoothctl power on # Turn on Bluetooth
bluetoothctl connect "2C:FD:B4:7C:0B:FB" > /dev/null # Connect to My Bluetooth Headphones Using it's MAC Address Without any Output
pactl set-default-sink "bluez_output.2C_FD_B4_7C_0B_FB.1" # Set it as Default Audio Output Device
