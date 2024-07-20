#!/bin/sh

capacity=$(cat /sys/class/power_supply/BAT0/capacity) # Get Current Battery Capacity

status=$(cat /sys/class/power_supply/BAT0/status) # Get Current Charging Status

# If Battery is X-Y% Range, then show "Z" icon

if [ "$capacity" -le 10 ]; then # 0-10%
    icon="⚠️"  
elif [ "$capacity" -le 20 ]; then # 10-20%
    icon=""   
elif [ "$capacity" -le 40 ]; then # 20-40%
    icon=""   
elif [ "$capacity" -le 60 ]; then # 40-60%
    icon=""   
elif [ "$capacity" -le 80 ]; then # 60-80%
    icon=""   
else
    icon=""    # 80-100%
fi

if [ "$status" = "Charging" ]; then # If Battery is Charging, Show Charging Icon.
    format="$capacity% "
  elif [ "$status" = "Full" ]; then # If Battery is Completely Full and Still Charging, show Heart Icon.
    format="$capacity% ♥ "
else
    format="$capacity% $icon " # Else, Show Icon according to above If-Else Conditions.
fi

echo "$format" # Print Relevant Format as the Output.
