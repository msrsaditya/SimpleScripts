#!/bin/sh
# Order of Checking for Media => Menu -> Media Type -> Screen Type -> Sound Type (If Exists)
Menu=(
    "Media" 
    "Wi-Fi" 
    "Bluetooth" 
    "Night-Light" 
    "Calculator"
    "Emoji Selector"
)

Media_Type=(
    "Screenshot"
    "Screen Record"
    "Webcam Record"
    "Screen & Webcam Record"
)

Screen_Type=(
    "Full Screen"
    "Select Screen"
)

Sound_Type=(
    "No Sound"
    "Only Internal Sounds"
    "Only Mic sounds"
    "All Sounds"
)

Webcam=(
    "Show Webcam"
    "Click a Picture"
    "Record Webcam"
    "Record Webcam with sound"
)

Toggle=(
  "On"
  "Off"
)

Bluetooth=(
   "On"
   "Off"
   "Search"
)

# Output Device --> Records Sounds Coming Out (Playing Inside Computer)
# Input Device --> Records Sounds Coming in (Playing Outside Computer) [If Input Device = External Microphone]
# If Input Device = Default Microphone => All Sounds Will be Recorded

inside_sound="alsa_output.pci-0000_00_1f.3.3.analog-stereo.monitor"
outside_sound="alsa_input.pci-0000_00_1f.3.3.analog-stereo"

menu_choice=$(printf '%s\n' "${Menu[@]}" | bemenu -p "")
case "$menu_choice" in
    "${Menu[0]}")
        media_choice=$(printf '%s\n' "${Media_Type[@]}" | bemenu -p "")
        case "$media_choice" in
            "${Media_Type[0]}")
                screen_type_choice=$(printf '%s\n' "${Screen_Type[@]}" | bemenu -p "")
                case "$screen_type_choice" in
                    "${Screen_Type[0]}")
                        mkdir -p ~/Pictures
                        grim ~/Pictures/screenshot.png
                        ;;
                    "${Screen_Type[1]}")
                        mkdir -p ~/Pictures
                        grim -g "$(slurp)" ~/Pictures/screenshot.png
                        ;;
                    *)
                        exit 1
                        ;;
                esac
                ;;
            "${Media_Type[1]}")
                screen_type_choice=$(printf '%s\n' "${Screen_Type[@]}" | bemenu -p "")
                case "$screen_type_choice" in
                    "${Screen_Type[0]}") 
                        sound_type_choice=$(printf '%s\n' "${Sound_Type[@]}" | bemenu -p "")
                        case "$sound_type_choice" in
                            "${Sound_Type[0]}")
                                mkdir -p ~/Videos
                                foot -e sh -c 'wf-recorder -f ~/Videos/recording.mp4'
                                ;;
                            "${Sound_Type[1]}")
                                mkdir -p ~/Videos
                                pactl set-default-source $inside_sound; foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                                ;;
                            "${Sound_Type[2]}")
                                mkdir -p ~/Videos
                                notify-send "Turn on Bluetooth"; pactl set-default-source $outside_sound; foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                                ;;
                            "${Sound_Type[3]}")
                                mkdir -p ~/Videos
                                notify-send "Turn off Bluetooth"; pactl set-default-source $outside_sound; foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                                ;;
                            *)
                                exit 1
                                ;;
                        esac
                        ;;
                    "${Screen_Type[1]}") 
                        sound_type_choice=$(printf '%s\n' "${Sound_Type[@]}" | bemenu -p ""  )
                        case "$sound_type_choice" in
                            "${Sound_Type[0]}")
                               mkdir -p ~/Videos
                               foot -e sh -c "wf-recorder -g '$(slurp)' -f ~/Videos/recording.mp4"
                                ;;
                            "${Sound_Type[1]}")
                               mkdir -p ~/Videos
                               pactl set-default-source $inside_sound; foot -e sh -c "wf-recorder -a -g '$(slurp)' -f ~/Videos/recording.mp4"
                                ;;
                            "${Sound_Type[2]}")
                                mkdir -p ~/Videos
                                notify-send "Turn on Bluetooth"; pactl set-default-source $outside_sound; foot -e sh -c "wf-recorder -a -g '$(slurp)' -f ~/Videos/recording.mp4"
                                ;;
                            "${Sound_Type[3]}")
                               mkdir -p ~/Videos
                               notify-send "Turn off Bluetooth";pactl set-default-source $outside_sound; foot -e sh -c "wf-recorder -a -g '$(slurp)' -f ~/Videos/recording.mp4"
                                ;;
                            *)
                                exit 1
                                ;;
                        esac
                        ;;
                    *)
                        exit 1
                        ;;
                esac
                ;;
            "${Media_Type[2]}")
                webcam_choice=$(printf '%s\n' "${Webcam[@]}" |bemenu -p "")
                case "$webcam_choice" in
                    "${Webcam[0]}")
                        foot -e sh -c 'ffplay -i /dev/video0 -fflags +nobuffer -vf hflip'
                        ;;
                    "${Webcam[1]}")
                        mkdir -p ~/Pictures
                        notify-send "Say Cheese!"; sleep 1 ; foot -e sh -c 'ffmpeg -f v4l2 -i /dev/video0 -frames 1 ~/Pictures/webcam.png';notify-send "Picture Captured!"
                        ;;
                    "${Webcam[2]}")
                        mkdir -p ~/Videos
                        foot -e sh -c 'ffmpeg -f v4l2 -i /dev/video0 -c:v h264 -preset ultrafast ~/Videos/recording.mp4'
                        ;;
                    "${Webcam[3]}")
                        mkdir -p ~/Videos
                        foot -e sh -c 'ffmpeg -f v4l2 -i /dev/video0 -f pulse -i default -c:v h264 -preset ultrafast ~/Videos/recording.mp4'
                        ;;
                    *)
                        exit 1
                        ;;
                esac
                ;;
            "${Media_Type[3]}")
                scrn_webcam_choice=$(printf '%s\n' "${Sound_Type[@]}" |bemenu -p ""  )
                case "$scrn_webcam_choice" in
                    "${Sound_Type[0]}")
                           mkdir -p ~/Videos
                           swaymsg "exec foot -t 'ffplay' -e sh -c 'ffplay -f v4l2 -fflags +nobuffer -i /dev/video0 -vf "hflip"'"; foot -e sh -c 'wf-recorder -f ~/Videos/recording.mp4'
                            ;;
                     "${Sound_Type[1]}")
                            mkdir -p ~Videos
                            swaymsg "exec foot -t 'ffplay' -e sh -c 'ffplay -f v4l2 -fflags +nobuffer -i /dev/video0 -vf "hflip"'";pactl set-default-source $inside_sound;foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                           ;;
                      "${Sound_Type[2]}")
                            mkdir -p ~/Videos
                            swaymsg "exec foot -t 'ffplay' -e sh -c 'ffplay -f v4l2 -fflags +nobuffer -i /dev/video0 -vf "hflip"'"; pactl set-default-source $outside_sound;  foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                           ;;
                      "${Sound_Type[3]}")
                             mkdir -p ~/Videos
                             swaymsg "exec foot -t 'ffplay' -e sh -c 'ffplay -f v4l2 -fflags +nobuffer -i /dev/video0 -vf "hflip"'";pactl set-default-source $outside_sound;foot -e sh -c 'wf-recorder -a -f ~/Videos/recording.mp4'
                           ;;
                    *)
                        exit 1
                        ;;
                esac
                ;;
            *)
                exit 1
                ;;
        esac
        ;;
    "${Menu[1]}")
        wifi_choice=$(printf '%s\n' "${Toggle[@]}" | bemenu -p "")
        case "$wifi_choice" in
            "${Toggle[0]}")
                nmcli radio wifi on;notify-send "Wi-Fi Turned on! 👍"
                ;;
            "${Toggle[1]}")
                nmcli radio wifi off;notify-send "Wi-Fi Turned off! 👎"
                ;;
            *)
                exit 1
                ;;
        esac
        ;;
    "${Menu[2]}")
        blue_choice=$(printf '%s\n' "${Bluetooth[@]}" | bemenu -p "")
        case "$blue_choice" in
            "${Bluetooth[0]}")
                bluetoothctl power on;notify-send "Bluetooth Turned on! 👍"
                ;;
            "${Bluetooth[1]}")
                bluetoothctl power off;notify-send "Bluetooth Turned off! 👎"
                ;;
            "${Bluetooth[2]}")
               sh /usr/local/bin/Scripts/Bluetooth/bluesearch.sh
               ;;
            *)
                exit 1
                ;;
        esac
        ;;
    "${Menu[3]}")
        ni8li8_choice=$(printf '%s\n' "${Toggle[@]}" | bemenu -p "")
        case "$ni8li8_choice" in
            "${Toggle[0]}")
               notify-send "Too Late...Time to Sleep! 😴";gammastep -o -O 2500 -P
                ;;
            "${Toggle[1]}")
                pkill gammastep
                ;;
            *)
                exit 1
                ;;
        esac
        ;;
    "${Menu[4]}")
        sh /usr/local/bin/Scripts/Tools/calc.sh
        ;;
    "${Menu[5]}")
        sh /usr/local/bin/Scripts/Tools/emoji.sh
        ;;
    *)
        exit 1
        ;;
esac 
