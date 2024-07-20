#!/bin/sh

options=("Shutdown" "Reboot" "Lock" "Sleep" "Logout") 
selected_option=$(printf '%s\n' "${options[@]}" | bemenu -p "")

case $selected_option in
    "Shutdown")
    confirm_shutdown=$(printf "Yes\nNo" | bemenu  -p "Are You Sure?") 
        if [ "$confirm_shutdown" = "Yes" ]; then
            exec systemctl poweroff
        fi
        ;;
    "Reboot")
        confirm_reboot=$(printf "Yes\nNo" | bemenu  -p "Are You Sure?")
        if [ "$confirm_reboot" = "Yes" ]; then
            exec systemctl reboot
        fi
        ;;
    "Lock")
            exec swaylock -c '#000000'
        ;;
    "Sleep")
            exec systemctl suspend
        ;;
    "Logout")
    confirm_logout=$(printf "Yes\nNo" | bemenu  -p "Are You Sure?")
        if [ "$confirm_logout" = "Yes" ]; then
            swaymsg exit
        fi
        ;;
        *)
        ;;
esac
