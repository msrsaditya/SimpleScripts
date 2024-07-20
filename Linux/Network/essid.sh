#!/bin/sh

# Check if Ethernet is Connected, If Yes Show It
if [[ $(cat /sys/class/net/enp0s20f0u3/carrier) == 1 ]]; then
    ip_addr=$(ip -4 addr show enp0s20f0u3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | awk 'NR==1')
    echo "$ip_addr "
# If Ethernet is Not Connected, Connect to Wi-Fi and Show it
else
    essid=$(iwconfig wlan0 | awk -F'"' '/ESSID:/{print $2}' | awk '{print $1}')
    if [ -z "$essid" ]; then
        echo "Disconnected ⚠️"
    else
        echo "$essid  "
    fi
fi

# Left Click (Touch) -- Show List of Available Wi-Fi Networks
if [ "$BLOCK_BUTTON" -eq 1 ]; then
    sh /usr/local/bin/Scripts/Network/wifi-connect.sh
fi
