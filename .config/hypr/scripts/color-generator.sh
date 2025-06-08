#!/bin/bash

# Generiši boje pomoću pywal
wal -i "$1" # slika kao argument

# Napravi Hyprland config fajl
OUT=~/.config/hypr/pywal-colors.conf

{
  echo "\$background = $(grep 'background=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$foreground = $(grep 'foreground=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color1 = $(grep 'color1=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color2 = $(grep 'color2=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color3 = $(grep 'color3=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color4 = $(grep 'color4=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color5 = $(grep 'color5=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color6 = $(grep 'color6=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color7 = $(grep 'color7=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color8 = $(grep 'color8=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color9 = $(grep 'color9=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color10 = $(grep 'color10=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color11 = $(grep 'color11=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color12 = $(grep 'color12=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color13 = $(grep 'color13=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color14 = $(grep 'color14=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
  echo "\$color15 = $(grep 'color15=' ~/.cache/wal/colors.sh | cut -d '=' -f2)"
} > "$OUT"

# Reload Hyprland (ili ručno: SUPER+SHIFT+R)
hyprctl reload
