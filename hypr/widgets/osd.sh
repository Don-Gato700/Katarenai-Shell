#!/bin/bash

# 1. Ejecutar la acción según el argumento
case $1 in
    vol_up)   pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    vol_down) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    vol_mute) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    bri_up)   brightnessctl set 5%+ ;;
    bri_down) brightnessctl set 5%- ;;
esac

# 2. Obtener los valores actuales para la notificación
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=%)' | head -n 1)
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
brightness=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

# 3. Enviar la notificación usando hints para la barra de progreso
# El ID 'osd_notification' asegura que la notificación se actualice en lugar de duplicarse
if [[ $1 == vol* ]]; then
    if [ "$is_muted" == "yes" ]; then
        notify-send -e -h string:x-canonical-private-synchronous:osd_notification \
            -u low -t 1200 -i audio-volume-muted "Silenciado"
    else
        notify-send -e -h string:x-canonical-private-synchronous:osd_notification \
            -h int:value:"$volume" -u low -t 1200 -i audio-volume-high "Volumen: $volume%"
    fi
elif [[ $1 == bri* ]]; then
    notify-send -e -h string:x-canonical-private-synchronous:osd_notification \
        -h int:value:"$brightness" -u low -t 1200 -i display-brightness "Brillo: $brightness%"
fi