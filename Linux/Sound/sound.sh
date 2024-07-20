#!/bin/sh

max_volume=155
min_volume=0

volume=$(pactl list sinks | awk '/Volume:/{print $5}' | head -n 1 | tr -d '%')

bluetooth_volume=$(pactl list sinks | awk '/^Sink #/{i++} i==2 && /Volume:/{print $5; exit}' | tr -d %)
bluetooth_status=$(bluetoothctl show | awk '/Powered:/ {print $2}')

#Icons

icons=("🔇" "" "" "" "⚠️")

if [ "$volume" -eq 0 ] || [ "$bluetooth_volume" -eq 0 ]; then 
    icon_index=0
elif [ "$volume" -lt 33 ] || [ "$bluetooth_volume" -lt 33 ] ; then
    icon_index=1
elif [ "$volume" -lt 66 ] || [ "$bluetooth_volume" -lt 66 ]; then
    icon_index=2
elif [ "$volume" -le 100 ] || [ "$bluetooth_volume" -le 100 ]; then
    icon_index=3
else
    icon_index=4
fi

icon="${icons[$icon_index]}"

# Which Format to show

if [ "$bluetooth_status" = "yes" ]; then
     echo "$bluetooth_volume% $icon" 
else
    echo "$volume% $icon"
fi

# 4-Scrollup, 5- Scrolldown Key Binds

if [ "$BLOCK_BUTTON" -eq 4 ]; then
    if [ "$volume" -lt "$max_volume" ] || [ "$bluetooth_volume" -lt "$max_volume" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ +5%
    fi
elif [ "$BLOCK_BUTTON" -eq 5 ]; then
    if [ "$volume" -gt "$min_volume" ] || [ "$bluetooth_volume" -lt "$min_volume" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ -5%
    fi
fi

# 1- Left-click(Tap), 3- Right-click Key Binds

if [ "$BLOCK_BUTTON" -eq 1 ]; then
    playerctl play-pause
elif [ "$BLOCK_BUTTON" -eq 3 ]; then
    /usr/local/bin/Scripts/Bluetooth/blueauto.sh
fi
