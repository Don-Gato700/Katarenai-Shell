#!/bin/bash

# Definir opciones con iconos de Nerd Fonts
opciones="󰐥 Apagar\n󰜉 Reiniciar\n󰤄 Suspender\n󰈆 Cerrar Sesión"

# Ejecutar rofi en modo dmenu con un estilo compacto
seleccionado=$(echo -e "$opciones" | rofi -dmenu -i -p "󰐥 Sys" -theme ~/.config/hypr/widgets/modern-split.rasi)

case "$seleccionado" in
    *Apagar) poweroff ;;
    *Reiniciar) reboot ;;
    *Suspender) systemctl suspend ;;
    *Cerrar*) hyprctl dispatch exit ;;
esac