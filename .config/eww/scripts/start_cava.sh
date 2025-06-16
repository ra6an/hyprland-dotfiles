#!/bin/bash

# Pokreni cava (ako nije već pokrenut)
pgrep cava > /dev/null || cava &

# Osiguraj da FIFO postoji
[ -p /tmp/cava_fifo ] || mkfifo /tmp/cava_fifo

# Otvori cava_widget ako već nije
# eww open cava_widget 2>/dev/null

# Čitanje podataka iz FIFO-a i ažuriranje eww-a
cat /tmp/cava_fifo | while read -r line; do
    bars=($line)
    json="["
    for b in "${bars[@]}"; do
        json+="$b,"
    done
    json="${json::-1}]"
    eww update CAVA_DATA="$json"
done
