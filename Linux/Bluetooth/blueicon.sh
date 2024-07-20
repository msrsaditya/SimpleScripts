#!/bin/sh

if bluetoothctl show | grep -q "Powered: yes"; then # If Bluetooth is turned on,
  echo ""  # Show Bluetooth Icon.
fi

if [ "$BLOCK_BUTTON" -eq 1 ]; then # If Clicked on this Block,
  /usr/local/bin/Scripts/Bluetooth/blueoff.sh # Execute blueoff.sh Script.
fi
