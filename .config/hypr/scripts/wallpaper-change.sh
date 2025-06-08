#!/bin/bash

# Provjera da je unesen argument
if [ -z "$1" ]; then
  echo "Usage: $0 <index>"
  exit 1
fi

# Parse argument
INDEX=$1

# Definiši 2D niz (lista lista)
wallpapers=(
  "$HOME/Pictures/Wallpapers/wpr.jpg" "$HOME/Pictures/Wallpapers/wpl.jpg"
  "$HOME/Pictures/Wallpapers/wpr2.jpg" "$HOME/Pictures/Wallpapers/wpl2.jpg"
  "$HOME/Pictures/Wallpapers/wpr3.jpg" "$HOME/Pictures/Wallpapers/wpl3.jpg"
)

# Izračunaj indeks u linearnom nizu
start_index=$(( (INDEX - 1) * 2 ))

# Validacija indeksa
if [ "$start_index" -ge "${#wallpapers[@]}" ]; then
  echo "Invalid index. Must be between 1 and $((${#wallpapers[@]} / 2))"
  exit 2
fi

# Uzmi desnu i lijevu pozadinu
RIGHT="${wallpapers[$start_index]}"
LEFT="${wallpapers[$((start_index + 1))]}"

# Pozovi set_wall skriptu
~/.config/hypr/scripts/set_wall.sh "$RIGHT" "$LEFT"
