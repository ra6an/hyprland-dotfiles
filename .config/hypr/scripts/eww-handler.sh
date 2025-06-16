#!/bin/bash

# Pokreni eww daemon samo ako već ne radi
# if ! pgrep -x "eww" > /dev/null; then
#     /usr/bin/eww daemon &
#     # Sačekaj da se eww zaista pokrene
#     while ! /usr/bin/eww windows &>/dev/null; do
#         sleep 0.1
#     done
# fi

/usr/bin/eww open-many header weather calendar favapps system