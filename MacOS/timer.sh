#!/bin/bash

# A Simple Script to Track Study Time with Features like Pausing, Resuming, Logging etc.

Bold="\033[1m"
Reset="\033[0m"
Blue="\033[34m"
Green="\033[32m"
Yellow="\033[33m"
Red="\033[31m"
Cyan="\033[36m"

LogFile="$HOME/.StudyLog"
CurrentDate=$(date "+%d-%B-%Y")

touch "$LogFile"

PrintHeader() {
    echo
    printf "${Bold}${Blue}==========================================================================================================${Reset}\n"
    printf "${Bold}${Blue}                                           📖 Study Tracker 📖                    ${Reset}\n"
    printf "${Bold}${Blue}==========================================================================================================${Reset}\n"
    echo
}

GetExistingTopic() {
    grep "^$CurrentDate" "$LogFile" | head -n 1 | sed -E 's/^[^"]*"([^"]*)".*$/\1/'
}

GetTotalTimeStudied() {
    grep "^$CurrentDate" "$LogFile" | awk '{print $NF}' | tail -n 1 || echo "00:00:00"
}

AddTime() {
    local Time1=$1
    local Time2=$2
    local Seconds1=$(echo "$Time1" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    local Seconds2=$(echo "$Time2" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
    local TotalSeconds=$((Seconds1 + Seconds2))
    printf "%02d:%02d:%02d\n" $((TotalSeconds / 3600)) $((TotalSeconds % 3600 / 60)) $((TotalSeconds % 60))
}

UpdateLogFile() {
    local StudyTime=$1
    local TempFile
    TempFile=$(mktemp)
    local Updated=false

    while IFS= read -r Line || [[ -n "$Line" ]]; do
        if [[ $Line == "$CurrentDate \"$Topic\""* ]]; then
            local ExistingTime=$(echo "$Line" | awk '{print $NF}')
            local NewTime
            NewTime=$(AddTime "$ExistingTime" "$StudyTime")
            echo "$CurrentDate \"$Topic\" $NewTime" >> "$TempFile"
            Updated=true
        else
            echo "$Line" >> "$TempFile"
        fi
    done < "$LogFile"

    if ! $Updated; then
        echo "$CurrentDate \"$Topic\" $StudyTime" >> "$TempFile"
    fi

    mv "$TempFile" "$LogFile"
}

ClearLine() {
    printf "\r%-80s\r" " "
}

SendNotification() {
    local Count=$1
    osascript -e "display notification \"${Count} Hours Studied! 🎉\" with title \"Good Job 👍\" sound name \"Glass\""
}

PrintHeader

ExistingTopic=$(GetExistingTopic)
TotalTimeStudied=$(GetTotalTimeStudied)

if [[ -n "$ExistingTopic" ]]; then
    Topic="$ExistingTopic"
    echo
    printf "${Cyan}Today's Topic 📚📚   : ${Green}${Topic}${Reset}\n"
    printf "${Cyan}Total Time Studied 🕒: ${Reset}${Green}${TotalTimeStudied}${Reset}"
    echo
    echo
else
    printf "${Cyan}Today's Topic 📚📚   : ${Reset}"
    read -r Topic
    printf "${Cyan}Total Time Studied 🕒: ${Reset}${Green}00:00:00${Reset}"
    echo
    echo
    TotalTimeStudied="00:00:00"
fi

StartTime=$(date +%s)
Paused=false
PauseStart=0
ActualStudyTime=0
ElapsedSeconds=0
NotificationCount=0

trap 'HandleExit' SIGINT

HandleExit() {
    ClearLine
    UpdatedTime=$(AddTime "$(printf "%02d:%02d:%02d\n" $((ActualStudyTime / 3600)) $((ActualStudyTime % 3600 / 60)) $((ActualStudyTime % 60)))" "$TotalTimeStudied")
    printf "You Studied ${Cyan}${Bold}%02d:%02d:%02d${Reset}. Total Updated Time is ${Cyan}${Bold}%s${Reset}\n\nKeep Up the Good Work! 👍\n\n" $((ActualStudyTime / 3600)) $((ActualStudyTime % 3600 / 60)) $((ActualStudyTime % 60)) "$UpdatedTime"
    UpdateLogFile "$(printf "%02d:%02d:%02d\n" $((ActualStudyTime / 3600)) $((ActualStudyTime % 3600 / 60)) $((ActualStudyTime % 60)))"
    exit 0
}

while true; do
    CurrentTime=$(date +%s)

    if $Paused; then
        PauseDuration=$((CurrentTime - PauseStart))
        if [[ $PauseDuration -gt 180 ]]; then
            ClearLine
            echo -e "\n${Red}Timer reset.${Reset}"
            StartTime=$CurrentTime
            Paused=false
            ActualStudyTime=0
            sleep 2
            echo
        fi
    else
        ElapsedTime=$((CurrentTime - StartTime))
        ActualStudyTime=$((ActualStudyTime + ElapsedTime))
        StartTime=$CurrentTime
    fi

    ElapsedSeconds=$((ElapsedSeconds + ElapsedTime))
    if [[ $ElapsedSeconds -ge 3600 ]]; then
        ((NotificationCount++))
        SendNotification "$NotificationCount"
        ElapsedSeconds=0
    fi

    Hours=$((ActualStudyTime / 3600))
    Minutes=$(((ActualStudyTime % 3600) / 60))
    Seconds=$((ActualStudyTime % 60))

    ClearLine
    if ! $Paused; then
        printf "${Green}⏱️ %02d:%02d:%02d ${Yellow}[P]ause ⏸️ ${Red}[Q]uit 🛑${Reset}" $Hours $Minutes $Seconds
    else
        RemainingReset=$((180 - PauseDuration))
        [[ $RemainingReset -lt 0 ]] && RemainingReset=0
        printf "${Yellow}⏱️ %02d:%02d:%02d ${Green}[R]esume ▶️ ${Green}[Q]uit 🛑${Red}(Reset in %d Seconds! 🔄)${Reset}" $Hours $Minutes $Seconds $RemainingReset
    fi

    read -t 1 -n 1 Key
    case $Key in
        [Pp])
            if ! $Paused; then
                Paused=true
                PauseStart=$CurrentTime
                ActualStudyTime=$((ActualStudyTime - ElapsedTime))
            fi
            ;;
        [Rr])
            if $Paused; then
                Paused=false
                StartTime=$CurrentTime
            fi
            ;;
        [Qq])
            HandleExit
            ;;
    esac
done
