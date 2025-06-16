#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Upotreba: $0 /putanja/do/slike.png /putanja/do/output/foldera/"
  exit 1
fi

input_image="$1"
output_dir="$2"

# Provjeri da li fajl postoji
if [ ! -f "$input_image" ]; then
  echo "Greška: Slika '$input_image' ne postoji."
  exit 1
fi

# Provjeri da li output folder postoji
if [ ! -d "$output_dir" ]; then
  echo "Greška: Output folder '$output_dir' ne postoji."
  exit 1
fi

# Dobij ime fajla bez ekstenzije
filename=$(basename -- "$input_image")
basename_noext="${filename%.*}"

# Učitaj dimenzije slike
width=$(identify -format "%w" "$input_image")
height=$(identify -format "%h" "$input_image")
half_width=$((width / 2))

echo "Režem '$input_image' ($width x $height) na $half_width px po širini."

# Izreži lijevu polovinu
magick "$input_image" -crop "${half_width}x${height}+0+0" "${output_dir}/${basename_noext}_left.jpg"

# Izreži desnu polovinu
magick "$input_image" -crop "${half_width}x${height}+${half_width}+0" "${output_dir}/${basename_noext}_right.jpg"

echo "Završeno. Slike spremljene u: $output_dir"
