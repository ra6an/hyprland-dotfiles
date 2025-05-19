#!/bin/bash

OPENED=false
/usr/bin/eww daemon

while true; do
    CURRENT_DESKTOP=$(hyprctl activeworkspace -j | jq '.id')
    EWW_PID=$(pidof -s eww)

    echo "EWW-PID: $EWW_PID ------ CURR-DSKTP: $CURRENT_DESKTOP"

    if [ "$EWW_PID" == "" ]; then
        # $HOME/eww/target/release/./eww open-many main
        /usr/bin/eww open-many header weather calendar favapps system
        OPENED=true

    elif [ "$CURRENT_DESKTOP" == "1" ] && [ "$EWW_PID" != "" ] && [ "$OPENED" == false ]; then
        # $HOME/eww/target/release/./eww open-many main
        /usr/bin/eww open-many header weather calendar favapps system
        OPENED=true

    elif [ "$CURRENT_DESKTOP" != "1" ] && [ "$EWW_PID" != "" ] && [ "$OPENED" = true ]; then
        # $HOME/eww/target/release/./eww close-all
        /usr/bin/eww close-all
        OPENED=false

    fi
    sleep 0.1
done