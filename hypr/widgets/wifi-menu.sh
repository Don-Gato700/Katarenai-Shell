#!/bin/bash

while true; do
    # 1. Escanear redes disponibles
    notify-send "WiFi" "Escaneando redes..." -t 1000
    redes=$(nmcli -t -f "SSID" dev wifi list | grep -v '^--' | sort -u)
    
    # Crear lista con opción de refresco al inicio
    lista_rofi="󰑐 Refrescar Lista\n$redes"

    # 2. Seleccionar Red
    seleccionada=$(echo -e "$lista_rofi" | rofi -dmenu -i -p "󰖩 WiFi")

    if [ -z "$seleccionada" ]; then
        exit 0
    fi

    if [[ "$seleccionada" == "󰑐 Refrescar Lista" ]]; then
        continue
    fi

    # 3. Comprobar si la red ya está guardada
    is_saved=$(nmcli -t -f NAME connection show | grep -Fx "$seleccionada")

    if [ -n "$is_saved" ]; then
        # 4. Submenú para redes conocidas
        opciones="󰖩 Conectar\n󱚥 Olvidar Red\n󰜺 Volver"
        accion=$(echo -e "$opciones" | rofi -dmenu -i -p "Red: $seleccionada")

        case "$accion" in
            *Conectar)
                notify-send "WiFi" "Conectando a $seleccionada..."
                nmcli connection up id "$seleccionada" | xargs -I {} notify-send "WiFi" "{}"
                exit 0
                ;;
            *Olvidar*)
                nmcli connection delete id "$seleccionada" && \
                notify-send "WiFi" "Red '$seleccionada' eliminada."
                continue
                ;;
            *)
                continue
                ;;
        esac
    else
        # 5. Red nueva: Pedir contraseña
        pass=$(rofi -dmenu -p "󰷦 Password" -password)
        
        if [ -n "$pass" ]; then
            notify-send "WiFi" "Intentando conexión nueva..."
            nmcli dev wifi connect "$seleccionada" password "$pass" | xargs -I {} notify-send "WiFi" "{}"
            exit 0
        else
            nmcli dev wifi connect "$seleccionada" | xargs -I {} notify-send "WiFi" "{}"
            exit 0
        fi
    fi
done