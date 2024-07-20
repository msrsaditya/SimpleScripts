#!/bin/sh

echo $(date +'%b %d %a') # Show Month, Date and Day in Short Format

 if [ "$BLOCK_BUTTON" -eq 1 ]; then # If Clicked on this Block,
    /usr/local/bin/Scripts/Tools/tools.sh # Execute tools.sh Script
fi
