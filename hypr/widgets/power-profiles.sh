#!/bin/bash

# Definir las opciones con iconos
opciones="󰓅 performance\n󰾅 balanced\n󰾆 power-saver"

# Abrir Rofi para seleccionar el perfil
seleccion=$(echo -e "$opciones" | rofi -dmenu -i -p "Perfil de Energía")

# Extraer el nombre del perfil seleccionado
case "$seleccion" in
    *performance) perfil="performance" ;;
    *balanced)    perfil="balanced" ;;
    *power-saver) perfil="power-saver" ;;
    *) exit 0 ;;
esac

powerprofilesctl set "$perfil"
notify-send "Energía" "Modo cambiado a: $perfil" -i battery -t 1000
pkill -RTMIN+8 waybar # Actualiza el icono en la barra inmediatamente