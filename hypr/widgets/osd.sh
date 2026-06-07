#!/bin/bash

# 1. Ejecutar la acción según el argumento
case $1 in
    vol_up)   wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    vol_down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    vol_mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
    bri_up)   brightnessctl set 5%+ ;;
    bri_down) brightnessctl set 5%- ;;
    mic_mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
esac

# 2. Obtener los valores actuales para la notificación
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1)
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "\[MUTED\]" && echo "yes" || echo "no")
brightness=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
mic_muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "\[MUTED\]" && echo "yes" || echo "no")

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
elif [[ $1 == mic* ]]; then
    if [ "$mic_muted" == "yes" ]; then
        notify-send -e -h string:x-canonical-private-synchronous:osd_notification \
            -u low -t 1200 -i microphone-sensitivity-muted-symbolic "Micrófono Desactivado"
    else
        notify-send -e -h string:x-canonical-private-synchronous:osd_notification \
            -u low -t 1200 -i microphone-sensitivity-high-symbolic "Micrófono Activado"
    fi
fi