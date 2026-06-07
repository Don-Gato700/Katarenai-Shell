#!/usr/bin/env bash

# Opciones usando códigos estables de Nerd Fonts (Candado, Salir, Luna, Recargar, Apagar)
lock=$(echo -e "\uf023")
logout=$(echo -e "\uf08b")
suspend=$(echo -e "\uf186")
reboot=$(echo -e "\uf01e")
shutdown=$(echo -e "\uf011")

# Pasar opciones a Rofi
chosen=$(echo -e "$lock\n$logout\n$suspend\n$reboot\n$shutdown" | rofi -dmenu -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
    "$lock") hyprlock ;;
    "$logout") hyprctl dispatch exit ;;
    "$suspend") systemctl suspend ;;
    "$reboot") systemctl reboot ;;
    "$shutdown") systemctl poweroff ;;
esac
