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

# pkill hyprpaper
# hyprpaper & disown
pgrep hyprpaper && pkill hyprpaper
nohup hyprpaper &>/dev/null &

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

# source ~/.cache/wal/colors.sh

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


# WLOGOUT SETUP

# Lokacija tvog style.css fajla
CSS_FILE="$HOME/.config/wlogout/style.css"

TMP_FILE=$(mktemp)

# Pywal boje (pretpostavljam da si ih već source-ovao prije ovoga)
NEW_TEXT_DECORATION_COLOR="$foreground"
NEW_TEXT_COLOR="$foreground"
NEW_BUTTON_BG_COLOR="$background"
NEW_HOVER_BG_COLOR="$color1"

awk -v tdc="$NEW_TEXT_DECORATION_COLOR" \
    -v tc="$NEW_TEXT_COLOR" \
    -v bg="$NEW_BUTTON_BG_COLOR" \
    -v hoverbg="$NEW_HOVER_BG_COLOR" '
{
    # Detekcija početka blokova
    if ($0 ~ /^button[[:space:]]*{/) in_button = 1
    if ($0 ~ /^button:focus, button:active, button:hover[[:space:]]*{/) in_hover = 1
    if ($0 ~ /^[[:space:]]*}/) {
        in_button = 0
        in_hover = 0
    }

    # Zamjene unutar button { ... }
    if (in_button) {
        gsub(/text-decoration-color:[[:space:]]*#[0-9a-fA-F]{6}/, "text-decoration-color: " tdc)
        gsub(/color:[[:space:]]*#[0-9a-fA-F]{6}/, "color: " tc)
        gsub(/background-color:[[:space:]]*#[0-9a-fA-F]{6}/, "background-color: " bg)
    }

    # Zamjena unutar hover bloka
    if (in_hover) {
        gsub(/background-color:[[:space:]]*#[0-9a-fA-F]{6}/, "background-color: " hoverbg)
    }

    print
}' "$CSS_FILE" > "$TMP_FILE"

# Backup prije zamjene
# cp "$CSS_FILE" "$CSS_FILE.bak"

# Zamjena
mv "$TMP_FILE" "$CSS_FILE"

# GTK CSS FILE UPDATE

# Generiši GTK CSS
cat > ~/.config/gtk-3.0/gtk.css <<EOF
@define-color foreground $foreground;
@define-color background $background;
@define-color color0 $color0;
@define-color color1 $color1;
@define-color color2 $color2;
@define-color color3 $color3;
@define-color color4 $color4;
@define-color color5 $color5;
@define-color color6 $color6;
@define-color color7 $color7;
EOF

# * {
#     background-color: @background;
#     color: @foreground;
# }

# button, entry, combobox, notebook, headerbar, menubar, toolbar {
#     background-color: @background;
#     color: @foreground;
#     border-color: @color1;
# }

cp ~/.config/gtk-3.0/gtk.css ~/.config/gtk-4.0/gtk.css

# UPDATE DISCORD COLORS

# Generate Discord theme

THEME_FILE="$HOME/.config/BetterDiscord/themes/pywal.theme.css"
COLORS_JSON="$HOME/.cache/wal/colors.json"

# Učitaj sve boje iz colors.json i napravi zamene u THEME_FILE liniju po liniju
jq -r '.colors | to_entries[] | "--" + .key + "=" + .value' "$COLORS_JSON" | while IFS='=' read -r var color; do
    # Escape za sed, zbog # u hex kodu
    color_escaped=$(printf '%s\n' "$color" | sed 's/[&/\]/\\&/g')
    # Zameni liniju u THEME_FILE koja počinje sa var (npr. --color1:)
    # regex traži liniju koja počinje belinom pa varijablom i zarezom na kraju
    sed -i "s/^\(\s*${var}:\s*\).*;/\1${color_escaped};/" "$THEME_FILE"
done

hex_color=$(jq -r '.colors.color0' "$COLORS_JSON")

# Konvertuj HEX (#rrggbb) u R, G, B
r=$((16#${hex_color:1:2}))
g=$((16#${hex_color:3:2}))
b=$((16#${hex_color:5:2}))

new_line="  --color-trans: rgba($r, $g, $b, 0.9);"

# Zamijeni liniju ako postoji, inače dodaj novu unutar :root bloka
if grep -q -- '--color-trans:' "$THEME_FILE"; then
    # Ako postoji, zamijeni vrijednost
    sed -i "s|^\s*--color-trans:.*|$new_line|" "$THEME_FILE"
else
    # Ako ne postoji, ubaci je tik iznad zatvarajuće } u :root
    sed -i "/^:root[[:space:]]*{/,/^}/{ 
        /^}/ i\\
$new_line
    }" "$THEME_FILE"
fi

# UPDATE SDDM THEME
sudo cp "$1" "/usr/share/sddm/themes/Sugar-Candy/Backgrounds/Background.jpg"
sudo sed -E -i "s|BackgroundColor=\"#([0-9a-fA-F]{6})\"|BackgroundColor=\"$background\"|g" /usr/share/sddm/themes/Sugar-Candy/theme.conf
sudo sed -E -i "s|MainColor=\"#([0-9a-fA-F]{6})\"|MainColor=\"$foreground\"|g" /usr/share/sddm/themes/Sugar-Candy/theme.conf
sudo sed -E -i "s|AccentColor=\"#([0-9a-fA-F]{6})\"|AccentColor=\"$color1\"|g" /usr/share/sddm/themes/Sugar-Candy/theme.conf