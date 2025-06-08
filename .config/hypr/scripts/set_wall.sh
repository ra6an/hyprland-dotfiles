#!/bin/bash

CONFIG="$HOME/.config/hypr/hyprpaper.conf"

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 /path/to/wall1.jpg [/path/to/wall2.jpg ...]"
  exit 1
fi

readarray -t MONITORS < <(hyprctl monitors | grep 'Monitor' | awk '{print $2}')

if [ "${#MONITORS[@]}" -eq 0 ]; then
  echo "No monitors found. Exiting."
  exit 1
fi

echo "Detected monitors:"
printf '%s\n' "${MONITORS[@]}"

echo "" > "$CONFIG"

for img in "$@"; do
  echo "preload = $img" >> "$CONFIG"
done

# Petlja za wallpapere
for i in "${!MONITORS[@]}"; do
  monitor="${MONITORS[$i]}"
  if [ "$i" -lt "$#" ]; then
    # indeks za slike, 0-based: uzimamo argument $((i+1))
    index=$((i))
    # Dohvati argument iz liste argumenata
    img="${@:$((index+1)):1}"
  else
    # Ako nema dovoljno slika, koristi poslednju
    img="${@: -1}"
  fi
  echo "wallpaper = $monitor, $img" >> "$CONFIG"
done

echo "Final hyprpaper.conf content:"
cat "$CONFIG"

pkill hyprpaper
hyprpaper & disown

wal -i "$1"

# Set colors for hyprland config
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
# bash ~/.config/hypr/scripts/color-generator.sh

# Reload dunst
bg=$(sed -n '1p' ~/.cache/wal/colors)
fg=$(sed -n '8p' ~/.cache/wal/colors)
hl=$(sed -n '2p' ~/.cache/wal/colors)

# Zamijeni boje SAMO unutar urgency_* sekcija
sed -i '/\[global\]/,/\[/{s/^    frame_color = .*/    frame_color = "'"$bg"'"/}' ~/.config/dunst/dunstrc

sed -i '/\[urgency_low\]/,/\[/{s/^    background = .*/    background = "'"$bg"'"/}' ~/.config/dunst/dunstrc
sed -i '/\[urgency_low\]/,/\[/{s/^    foreground = .*/    foreground = "'"$fg"'"/}' ~/.config/dunst/dunstrc

sed -i '/\[urgency_normal\]/,/\[/{s/^    background = .*/    background = "'"$bg"'"/}' ~/.config/dunst/dunstrc
sed -i '/\[urgency_normal\]/,/\[/{s/^    foreground = .*/    foreground = "'"$fg"'"/}' ~/.config/dunst/dunstrc

sed -i '/\[urgency_critical\]/,/\[/{s/^    background = .*/    background = "'"$bg"'"/}' ~/.config/dunst/dunstrc
sed -i '/\[urgency_critical\]/,/\[/{s/^    foreground = .*/    foreground = "'"$fg"'"/}' ~/.config/dunst/dunstrc
sed -i '/\[urgency_critical\]/,/\[/{s/^    frame_color = .*/    frame_color = "'"$hl"'"/}' ~/.config/dunst/dunstrc

# Restartuj dunst
pkill dunst && dunst &

# Copy/Paste colors for waybar
cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors-waybar.css

# Reload waybar
pkill waybar 
waybar &

# Reload eww
eww reload

# Change colors for kitty

WAL_COLORS=~/.cache/wal/colors.sh
KITTY_CONFIG=~/.config/kitty/kitty.conf

# Učitaj boje iz wal fajla
source "$WAL_COLORS"

# Napravi backup
cp "$KITTY_CONFIG" "$KITTY_CONFIG.bak"

# Funkcija za escape specijalnih karaktera za sed
escape_sed() {
  echo "$1" | sed -e 's/[\/&]/\\&/g'
}

# Escapuj sve boje zbog sed
bg_escaped=$(escape_sed "$background")
fg_escaped=$(escape_sed "$foreground")
cursor_escaped=$(escape_sed "$color6")  # cursor boja iz pywal color6

# Update background
sed -i "s/^background\s\+.*/background              $bg_escaped/" "$KITTY_CONFIG"

# Update foreground
sed -i "s/^foreground\s\+.*/foreground              $fg_escaped/" "$KITTY_CONFIG"

# Update cursor
sed -i "s/^cursor\s\+.*/cursor                  $cursor_escaped/" "$KITTY_CONFIG"

# Update color0 - color7
for i in {0..7}; do
  # Uzmi varijablu colorX iz wal
  color_var="color$i"
  # Koristi indirektno expansion za varijablu iz source fajla
  color_val="${!color_var}"
  color_escaped=$(escape_sed "$color_val")
  sed -i "s/^color$i\s\+.*/color$i  $color_escaped/" "$KITTY_CONFIG"
done

# Hyprland config file update

source ~/.cache/wal/colors.sh

# Funkcija za konverziju
hex_to_rgba() {
  local hex=${1#"#"}
  local alpha=${2:-ff}
  if [[ ${#hex} -eq 6 ]]; then
    echo "rgba(${hex}${alpha})"
  elif [[ ${#hex} -eq 8 ]]; then
    echo "rgba(${hex})"
  else
    echo "rgba(000000${alpha})"
  fi
}

# Izaberi boju koju zelis (npr color1)
inactivecolor=$(hex_to_rgba "$background" "ff")
newcolor=$(hex_to_rgba "$color1" "ff")  # alpha cc = 80% providnost
newcolor2=$(hex_to_rgba "$color6" "ff")

# Fajl u kome menjamo
configfile=~/.config/hypr/hyprland.conf

# Koristimo sed da promenimo liniju koja pocinje sa col.active_border
# Ovde menja prvu boju u rgba(8b2e2eff) na novu boju iz pywal

sed -i -E "s|(col\.active_border = )rgba\([0-9a-fA-F]{8}\) rgba\([0-9a-fA-F]{8}\)|\1${newcolor} ${newcolor2}|" "$configfile"
sed -i -E "s/(col\.inactive_border = )rgba\([0-9a-fA-F]{8}\)/\1$inactivecolor/" "$configfile"

# RASI SETUP

RASI_FILE="$HOME/.config/rofi/themes/r6n.rasi"

echo "background=$background"
echo "foreground=$foreground"
echo "color1=$color1"
echo "color5=$color5"


# Zameni boje samo u linijama koje počinju sa tim imenima
sed -Ei \
    -e "s/^\s*my-bg0:\s*#[0-9a-fA-F]{6,8};/    my-bg0:     $background;/" \
    -e "s/^\s*my-bg1:\s*#[0-9a-fA-F]{6,8};/    my-bg1:     $background;/" \
    -e "s/^\s*my-bg2:\s*#[0-9a-fA-F]{6,8};/    my-bg2:     $foreground;/" \
    -e "s/^\s*my-accent-color:\s*#[0-9a-fA-F]{6,8};/    my-accent-color:     $color1;/" \
    -e "s/^\s*my-urgent-color:\s*#[0-9a-fA-F]{6,8};/    my-urgent-color: $color5;/" \
    "$RASI_FILE"