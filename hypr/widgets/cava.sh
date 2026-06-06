#!/bin/bash

config_file="/tmp/cava_config_waybar"
cat <<EOF > "$config_file"
[general]
bars = 10
sleep = 0

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Asegurarnos de que el proceso se limpie al cerrar Waybar
trap "pkill -P $$" EXIT

# Ejecutar CAVA y procesar la salida hacia Waybar
# El flag -u de sed debe estar separado para evitar errores de sintaxis
cava -p "$config_file" | sed -u '
    s/;//g
    y/01234567/ ▂▃▄▅▆▇█/
    /[^ ]/! { s/.*/{"text": "", "class": "empty"}/; b }
    s/.*/{"text": "&", "class": "active"}/
'