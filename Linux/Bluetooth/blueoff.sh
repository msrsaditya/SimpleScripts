#!/bin/sh

if [ "$(echo -e "Yes\nNo" | bemenu -p "Power Off?")" = "Yes" ]; then # If Yes option is selected in Yes/No options in the Menu, 
    bluetoothctl power off # Turn off Bluetooth, otherwise do nothing.
fi
