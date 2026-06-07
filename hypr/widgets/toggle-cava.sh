#!/bin/bash
TOGGLE="/tmp/cava_disabled"

# Si el archivo existe, lo quitamos (activar). Si no, lo creamos (desactivar).
if [ -f "$TOGGLE" ]; then
    rm "$TOGGLE"
    # Matamos cualquier instancia huérfana para asegurar un arranque limpio
    pkill -9 -x "cava"
    notify-send "Sistema" "CAVA activado" -i audio-speakers -t 2000
else
    touch "$TOGGLE"
    pkill -9 -x "cava"
    notify-send "Sistema" "CAVA desactivado (Ahorro de energía)" -i processor -t 2000
fi