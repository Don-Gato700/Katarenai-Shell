#!/usr/bin/env bash

# Obtener volumen actual y estado de red
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | tr -d '%')
WIFI=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d\' -f2 | sed 's/^yes://')
[ -z "$WIFI" ] && WIFI="Desconectado"

# Menú Principal estilo Noctalia
MENU_OPTIONS="󰓃  Volumen Actual: ${VOL}%\n󰖩  Wi-Fi: ${WIFI}\n󰂯  Bluetooth\n󰃠  Brillo Pantalla"

CHOSEN=$(echo -e "$MENU_OPTIONS" | rofi -dmenu -p "Control Center" -theme ~/.config/rofi/control-center.rasi)

case "$CHOSEN" in
    *󰓃*)
        # Sub-menú rápido de volumen
        VOL_OPTS="󰝝  Subir Volumen (+10%)\n󰝞  Bajar Volumen (-10%)\n󰝟  Mutear / Desmutear"
        SUB_CHOSEN=$(echo -e "$VOL_OPTS" | rofi -dmenu -p "Ajustar Audio" -theme ~/.config/rofi/control-center.rasi)
        case "$SUB_CHOSEN" in
            *Subir*) pactl set-sink-volume @DEFAULT_SINK@ +10% ;;
            *Bajar*) pactl set-sink-volume @DEFAULT_SINK@ -10% ;;
            *Mutear*) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
        esac
        ;;
    *󰖩*)
        # Llama de una vez al menú vertical de redes que ya hicimos y funciona impecable
        networkmanager_dmenu -config ~/.config/rofi/redes.rasi
        ;;
    *󰂯*)
        ~/.config/rofi/rofi-bluetooth.sh
        ;;
esac
