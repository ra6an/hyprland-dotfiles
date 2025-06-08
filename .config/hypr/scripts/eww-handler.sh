#!/bin/bash

# ONE MONITOR SCRIPT---------------------
# OPENED=false
# /usr/bin/eww daemon

# while true; do
#     CURRENT_DESKTOP=$(hyprctl activeworkspace -j | jq '.id')
#     EWW_PID=$(pidof -s eww)

#     echo "EWW-PID: $EWW_PID ------ CURR-DSKTP: $CURRENT_DESKTOP"

#     if [ "$EWW_PID" == "" ]; then
#         # $HOME/eww/target/release/./eww open-many main
#         /usr/bin/eww open-many header weather calendar favapps system
#         OPENED=true

#     elif [ "$CURRENT_DESKTOP" == "1" ] && [ "$EWW_PID" != "" ] && [ "$OPENED" == false ]; then
#         # $HOME/eww/target/release/./eww open-many main
#         /usr/bin/eww open-many header weather calendar favapps system
#         OPENED=true

#     elif [ "$CURRENT_DESKTOP" != "1" ] && [ "$EWW_PID" != "" ] && [ "$OPENED" = true ]; then
#         # $HOME/eww/target/release/./eww close-all
#         /usr/bin/eww close-all
#         OPENED=false

#     fi
#     sleep 0.1
# done
# ONE MONITOR SCRIPT---------------------

MONITOR_NAME="HDMI-A-1"
WANTED_WS_ID=1
WIDGETS="header calendar favapps system"
/usr/bin/eww daemon

eww close-all

socat - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    if [[ "$line" == *"workspace>>"* || "$line" == *"monitorlayout>>"* ]]; then
        MONITORS_JSON=$(hyprctl monitors -j)
        CURRENT_WS_ON_MON=$(echo "$MONITORS_JSON" | jq -r --arg MON "$MONITOR_NAME" '.[] | select(.name == $MON) | .activeWorkspace.id')

        if [[ "$CURRENT_WS_ON_MON" == "$WANTED_WS_ID" ]]; then
            eww open-many "$WIDGETS"
        else
            eww close-all
        fi
    fi
done