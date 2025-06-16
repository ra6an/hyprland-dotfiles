#!/bin/bash

SAVE_PATH="$1"
YOUTUBE_URL="$2"
CUSTOM_NAME="$3"

# Provjera da li su unijeti svi parametri
if [ -z "$SAVE_PATH" ] || [ -z "$YOUTUBE_URL" ]; then
    echo "❌ Korištenje: $0 /putanja/za/spasavanje URL [NazivFajlaBezEkstenzije]"
    exit 1
fi

# Provjera da li yt-dlp postoji
if ! command -v yt-dlp &> /dev/null; then
    echo "❌ Greška: 'yt-dlp' nije instaliran. Instaliraj ga komandama:"
    echo "    sudo pacman -S yt-dlp"
    exit 2
fi

# Provjera da li folder postoji
if [ ! -d "$SAVE_PATH" ]; then
    echo "❌ Greška: folder '$SAVE_PATH' ne postoji."
    exit 3
fi

# Određivanje izlaznog imena
if [ -z "$CUSTOM_NAME" ]; then
    OUTPUT_TEMPLATE="%(title)s.%(ext)s"
else
    OUTPUT_TEMPLATE="${CUSTOM_NAME}.%(ext)s"
fi

# Skidanje i konverzija
yt-dlp  --no-playlist \
        -P "$SAVE_PATH" \
        -x --audio-format mp3 --audio-quality 0 \
        -o "$OUTPUT_TEMPLATE" \
        "$YOUTUBE_URL"

echo "✅ Završeno! Provjeri u: $SAVE_PATH"
