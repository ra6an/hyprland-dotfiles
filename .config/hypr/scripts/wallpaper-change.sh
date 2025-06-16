#!/bin/bash

# # Provjera da je unesen argument
# if [ -z "$1" ]; then
#   echo "Usage: $0 <index>"
#   exit 1
# fi

# # Parse argument
# INDEX=$1

# # Definiši 2D niz (lista lista)
# wallpapers=(
#   "$HOME/Pictures/Wallpapers/pattern_right.jpg|$HOME/Pictures/Wallpapers/pattern_left.jpg"
#   "$HOME/Pictures/Wallpapers/wpr2.jpg|$HOME/Pictures/Wallpapers/wpl2.jpg"
#   "$HOME/Pictures/Wallpapers/wpr3.jpg|$HOME/Pictures/Wallpapers/wpl3.jpg"
#   "$HOME/Pictures/Wallpapers/sakura_right.jpg|$HOME/Pictures/Wallpapers/sakura_left.jpg"
#   "$HOME/Pictures/Wallpapers/gengar_right.jpg|$HOME/Pictures/Wallpapers/gengar_left.jpg"
#   "$HOME/Pictures/Wallpapers/drawing_right.jpg|$HOME/Pictures/Wallpapers/drawing_left.jpg"
#   "$HOME/Pictures/Wallpapers/galaxy_right.jpg|$HOME/Pictures/Wallpapers/galaxy_left.jpg"
#   "$HOME/Pictures/Wallpapers/painting_right.jpg|$HOME/Pictures/Wallpapers/painting_left.jpg"
#   "$HOME/Pictures/Wallpapers/tree_right.jpg|$HOME/r6n/Pictures/Wallpapers/tree_left.jpg"
#   "$HOME/Pictures/Wallpapers/pattern_right.jpg|$HOME/Pictures/Wallpapers/pattern_left.jpg"
# )

# # Izračunaj indeks u linearnom nizu
# start_index=$(( (INDEX - 1) * 2 ))

# # Validacija indeksa
# if [ "$start_index" -ge "${#wallpapers[@]}" ]; then
#   echo "Invalid index. Must be between 1 and $((${#wallpapers[@]} / 2))"
#   exit 2
# fi

# # Uzmi desnu i lijevu pozadinu
# # RIGHT="${wallpapers[$start_index]}"
# # LEFT="${wallpapers[$((start_index + 1))]}"
# IFS='|' read -r RIGHT LEFT <<< "${wallpapers[$INDEX]}"

# # Pozovi set_wall skriptu
# ~/.config/hypr/scripts/set_wall.sh "$RIGHT" "$LEFT"

######################### NOVA SKRIPTA #########################

wallpapers=(
  "Corosion|$HOME/Pictures/Wallpapers/wpr3.jpg|$HOME/Pictures/Wallpapers/wpl3.jpg"
  "Pattern|$HOME/Pictures/Wallpapers/pattern_right.jpg|$HOME/Pictures/Wallpapers/pattern_left.jpg"
  "Stones|$HOME/Pictures/Wallpapers/stones_right.jpg|$HOME/Pictures/Wallpapers/stones_left.jpg"
  "Reflection|$HOME/Pictures/Wallpapers/reflection_right.jpg|$HOME/Pictures/Wallpapers/reflection_left.jpg"
  "Purple|$HOME/Pictures/Wallpapers/wpr2.jpg|$HOME/Pictures/Wallpapers/wpl2.jpg"
  "Sakura|$HOME/Pictures/Wallpapers/sakura_right.jpg|$HOME/Pictures/Wallpapers/sakura_left.jpg"
  "Japan2|$HOME/Pictures/Wallpapers/japan2_right.jpg|$HOME/Pictures/Wallpapers/japan2_left.jpg"
  "Japan3|$HOME/Pictures/Wallpapers/japan3_right.jpg|$HOME/Pictures/Wallpapers/japan3_left.jpg"
  "Girl|$HOME/Pictures/Wallpapers/girl_right.jpg|$HOME/Pictures/Wallpapers/girl_left.jpg"
  "Girl2|$HOME/Pictures/Wallpapers/girl2_right.jpg|$HOME/Pictures/Wallpapers/girl2_left.jpg"
  "Mountain|$HOME/Pictures/Wallpapers/mountain_right.jpg|$HOME/Pictures/Wallpapers/mountain_left.jpg"
  "Forest|$HOME/Pictures/Wallpapers/forest_right.jpg|$HOME/Pictures/Wallpapers/forest_left.jpg"
  "Forest2|$HOME/Pictures/Wallpapers/forest2_right.jpg|$HOME/Pictures/Wallpapers/forest2_left.jpg"
  "Forest3|$HOME/Pictures/Wallpapers/forest3_right.jpg|$HOME/Pictures/Wallpapers/forest3_left.jpg"
  "Snow|$HOME/Pictures/Wallpapers/snow_right.jpg|$HOME/Pictures/Wallpapers/snow_left.jpg"
  "TreeSepia|$HOME/Pictures/Wallpapers/tree_right.jpg|$HOME/Pictures/Wallpapers/tree_left.jpg"
  "TreeGogh|$HOME/Pictures/Wallpapers/treegogh_right.jpg|$HOME/Pictures/Wallpapers/treegogh_left.jpg"
  "LPTree|$HOME/Pictures/Wallpapers/lptree_right.jpg|$HOME/Pictures/Wallpapers/lptree_left.jpg"
  "LowPoly|$HOME/Pictures/Wallpapers/lowpoly_right.jpg|$HOME/Pictures/Wallpapers/lowpoly_left.jpg"
  "Gengar|$HOME/Pictures/Wallpapers/gengar_right.jpg|$HOME/Pictures/Wallpapers/gengar_left.jpg"
  "Drawing|$HOME/Pictures/Wallpapers/drawing_right.jpg|$HOME/Pictures/Wallpapers/drawing_left.jpg"
  "Painting|$HOME/Pictures/Wallpapers/painting_right.jpg|$HOME/Pictures/Wallpapers/painting_left.jpg"
  "Painting2|$HOME/Pictures/Wallpapers/painting2_right.jpg|$HOME/Pictures/Wallpapers/painting2_left.jpg"
  "Galaxy|$HOME/Pictures/Wallpapers/galaxy_right.jpg|$HOME/Pictures/Wallpapers/galaxy_left.jpg"
  "Galaxy2|$HOME/Pictures/Wallpapers/space_right.jpg|$HOME/Pictures/Wallpapers/space_left.jpg"
  "Walle|$HOME/Pictures/Wallpapers/walle_right.jpg|$HOME/Pictures/Wallpapers/walle_left.jpg"
  "Trooper|$HOME/Pictures/Wallpapers/trooper_right.jpg|$HOME/Pictures/Wallpapers/trooper_left.jpg"
  "Trooper2|$HOME/Pictures/Wallpapers/trooper2_right.jpg|$HOME/Pictures/Wallpapers/trooper2_left.jpg"
  "Wolf|$HOME/Pictures/Wallpapers/wolf_right.jpg|$HOME/Pictures/Wallpapers/wolf_left.jpg"
  "Horse|$HOME/Pictures/Wallpapers/horse_right.jpg|$HOME/Pictures/Wallpapers/horse_left.jpg"
  "Whale|$HOME/Pictures/Wallpapers/whale_right.jpg|$HOME/Pictures/Wallpapers/whale_left.jpg"
  "Hell|$HOME/Pictures/Wallpapers/hell_right.jpg|$HOME/Pictures/Wallpapers/hell_left.jpg"
  "Future|$HOME/Pictures/Wallpapers/future_right.jpg|$HOME/Pictures/Wallpapers/future_left.jpg"
  "Building|$HOME/Pictures/Wallpapers/building_right.jpg|$HOME/Pictures/Wallpapers/building_left.jpg"
)

# Napravi listu samo imena setova za prikaz u meniju
options=()
for entry in "${wallpapers[@]}"; do
  IFS='|' read -r name _ <<< "$entry"
  options+=("$name")
done

# Prikaži meni i uzmi izbor korisnika
chosen=$(printf "%s\n" "${options[@]}" | rofi -dmenu -p "Choose Wallpaper Set" -theme "~/.config/rofi/themes/r6n.rasi")

# Ako korisnik izađe bez izbora
[ -z "$chosen" ] && exit 0

# Nađi odgovarajući set na osnovu izbora
for entry in "${wallpapers[@]}"; do
  IFS='|' read -r name right left <<< "$entry"
  if [ "$name" == "$chosen" ]; then
    ~/.config/hypr/scripts/set_wall.sh "$right" "$left"
    exit 0
  fi
done

# Ako iz nekog razloga nije pronađen odgovarajući set
echo "Wallpaper set not found."
exit 1
