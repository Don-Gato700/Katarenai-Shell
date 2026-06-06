#!/bin/bash

# Directorio de capturas
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

FILENAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
FILEPATH="$DIR/$FILENAME"

case $1 in
    full)
        grim "$FILEPATH"
        ;;
    region)
        # Requiere slurp para seleccionar el área
        grim -g "$(slurp)" "$FILEPATH"
        ;;
esac

# Si el archivo se creó correctamente, copiar al portapapeles y notificar
if [ -f "$FILEPATH" ]; then
    wl-copy < "$FILEPATH"
    notify-send "Captura de pantalla" "Guardada en $FILENAME y copiada al portapapeles" -i camera-photo -t 2000
fi