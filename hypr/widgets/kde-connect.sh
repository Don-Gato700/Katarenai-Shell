#!/bin/bash

# Obtener la lista de dispositivos (solo nombres)
devices=$(kdeconnect-cli -l --name-only)

if [ -z "$devices" ]; then
    notify-send "KDE Connect" "No se encontraron dispositivos" -i phone -t 2000
    exit 1
fi

# Seleccionar dispositivo con Rofi
device_name=$(echo -e "$devices" | rofi -dmenu -i -p "󰄜 Dispositivos" -theme ~/.config/hypr/widgets/modern-split.rasi)

[ -z "$device_name" ] && exit 0

while true; do
    # Extraer el ID y el estado actual del dispositivo seleccionado
    device_info=$(kdeconnect-cli -l | grep "$device_name")
    device_id=$(echo "$device_info" | awk -F': ' '{print $2}' | awk '{print $1}')
    
    # Menú de acciones
    action=$(echo -e "󰂚 Ping (Hacer sonar)\n󰁹 Ver Estado\n󰄬 Comprobar Conexión\n󰗃 Enviar Portapapeles\n󰈔 Enviar Archivo\n󰄄 Vincular\n󰜺 Volver al Inicio\n󰈆 Salir" | rofi -dmenu -i -p "Acción: $device_name" -theme ~/.config/hypr/widgets/modern-split.rasi)

    case "$action" in
        *Ping*) 
            kdeconnect-cli -d "$device_id" --ring 
            ;;
        *Estado*) 
            status=$(kdeconnect-cli -d "$device_id" --refresh | grep -i "Battery" || echo "Dispositivo conectado")
            notify-send "KDE Connect" "$device_name: $status" -i phone -t 3000 
            ;;
        *Conexión*)
            if kdeconnect-cli -l | grep "$device_id" | grep -q "is reachable"; then
                notify-send "KDE Connect" "󰄬 $device_name está conectado y visible" -i phone -t 2000
            else
                notify-send "KDE Connect" "󰂭 $device_name no está disponible" -u critical -i phone -t 2000
            fi
            ;;
        *Portapapeles*) 
            kdeconnect-cli -d "$device_id" --share-text "$(wl-paste)" && \
            notify-send "KDE Connect" "Texto enviado a $device_name" -i phone -t 2000 
            ;;
        *Archivo*)
            file_path=$(zenity --file-selection --title="Selecciona un archivo para enviar a $device_name")
            if [ -n "$file_path" ]; then
                notify-send "KDE Connect" "Enviando archivo..." -i phone -t 1500
                kdeconnect-cli -d "$device_id" --share "$file_path" && \
                notify-send "KDE Connect" "Archivo enviado con éxito" -i phone -t 2000
            fi
            ;;
        *Vincular*) 
            kdeconnect-cli -d "$device_id" --pair 
            ;;
        *Volver*) 
            exec "$0" # Reinicia el script para elegir otro dispositivo
            ;;
        *Salir*|"") 
            exit 0 
            ;;
    esac
done