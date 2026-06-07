#!/bin/bash

# Evitar múltiples instancias y limpiar procesos huérfanos de ejecuciones previas
if pidof -x "$(basename "$0")" -o $$ > /dev/null; then
    exit 0
fi
# Matar procesos de cava antiguos que pudieran haber quedado colgados
pkill -u "$USER" -x cava 2>/dev/null

config_file="/tmp/cava_config_waybar"
cat <<EOF > "$config_file"
[general]
bars = 10
framerate = 25

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Asegurarnos de que el proceso se limpie al cerrar Waybar
trap "pkill -P $$; exit" EXIT SIGINT SIGTERM

while true; do
    if [[ -f /tmp/cava_disabled ]]; then
        # Modo ahorro: enviamos vacío y esperamos
        echo '{"text": "", "class": "disabled"}'
        # Polling mucho más lento cuando está desactivado
        while [ -f /tmp/cava_disabled ]; do sleep 2; done
    else
        # Ejecutar CAVA optimizado
        stdbuf -oL cava -p "$config_file" 2>/dev/null | stdbuf -oL sed -u '
            s/;//g
            y/01234567/ ▂▃▄▅▆▇█/
            /[^ ]/! { s/.*/{"text": "", "class": "empty"}/; b }
            s/.*/{"text": "&", "class": "active"}/
        '
    fi
    sleep 1
done