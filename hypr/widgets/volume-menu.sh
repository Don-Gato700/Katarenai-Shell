#!/bin/bash

opciones="󰝟 Silenciar/Activar\n󰕿 25%\n󰖀 50%\n󰕾 75%\n󰕾 100%\n󰓃 Abrir Mezclador"

seleccionado=$(echo -e "$opciones" | rofi -dmenu -i -p "󰕾 Vol" -theme ~/.config/hypr/widgets/modern-split.rasi)

case "$seleccionado" in
    *Silenciar*) ~/.config/hypr/widgets/volume.sh mute ;;
    *25%) wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.25 && notify-send "Volumen" "25%" -h int:value:25 ;;
    *50%) wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.50 && notify-send "Volumen" "50%" -h int:value:50 ;;
    *75%) wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75 && notify-send "Volumen" "75%" -h int:value:75 ;;
    *100%) wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 && notify-send "Volumen" "100%" -h int:value:100 ;;
    *Mezclador*) pavucontrol ;;
esac