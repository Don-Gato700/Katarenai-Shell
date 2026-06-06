#!/bin/bash

# Función para obtener el volumen actual y estado de silencio
get_vol() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}' | cut -d. -f1
}

is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "\[MUTED\]" && echo "yes" || echo "no"
}

case $1 in
    up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
    down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
    mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

# Enviar notificación (usando un ID síncrono para que no se apilen)
if [ "$(is_muted)" = "yes" ]; then
    notify-send -h string:x-canonical-private-synchronous:volume -i audio-volume-muted "Silenciado" -t 1000
else
    VOL=$(get_vol)
    notify-send -h string:x-canonical-private-synchronous:volume -h int:value:"$VOL" -i audio-volume-high "Volumen: $VOL%" -t 1000
fi