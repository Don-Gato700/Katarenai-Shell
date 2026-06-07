#!/bin/bash

# Comprobar dependencias
command -v playerctl >/dev/null 2>&1 || exit 1
command -v jq >/dev/null 2>&1 || exit 1

# Evitar múltiples instancias (Comentado para pruebas, descomenta si funciona bien)
# if [[ "$1" != "--show-art" ]] && pidof -x $(basename "$0") -o $$ > /dev/null; then
#     exit 0
# fi

get_data() {
    local metadata=$(playerctl metadata --format '{{status}}|{{title}}|{{artist}}|{{playerName}}|{{mpris:length}}|{{position}}' 2>/dev/null)
    
    # Si no hay metadatos, mostrar un estado base en lugar de nada
    if [[ -z "$metadata" ]]; then
        echo '{"text": "Sin música", "class": "stopped", "tooltip": "No hay reproductores activos"}'
        return
    fi

    IFS='|' read -r status title artist player_name len_us pos_us <<< "$metadata"

    # Limpieza de comillas
    title="${title//\"/}"
    artist="${artist//\"/}"

    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        icon=$([[ "$status" == "Playing" ]] && echo "󰎆" || echo "󰏤")
        action_icon=$([[ "$status" == "Playing" ]] && echo "󰏤" || echo "󰐊")

        # Acortar título si es muy largo
        display_text="${title:0:20}"
        [[ ${#title} -gt 20 ]] && display_text="${display_text}..."

        # Cálculo de tiempo y progreso
        local pos=$(( ${pos_us:-0} / 1000000 ))
        if [[ -n "$len_us" && "$len_us" -gt 0 ]]; then
            progress=$(( pos * 100 / (len_us / 1000000) ))
            len_s=$(( len_us / 1000000 ))
            time_info="$(printf "%d:%02d" $((pos/60)) $((pos%60))) / $(printf "%d:%02d" $((len_s/60)) $((len_s%60)))"
        else
            progress=0
            time_info="--:-- / --:--"
        fi
        
        jq -n \
            --arg text "$icon $display_text" \
            --arg class "$(echo "$status" | tr '[:upper:]' '[:lower:]')" \
            --arg tooltip "$title - $artist ($player_name) [$time_info]" \
            --arg p "$progress" --arg t "$title" --arg a "$artist" --arg i "$action_icon" --arg pl "$player_name" --arg ti "$time_info" \
            '{text: $text, class: $class, tooltip: $tooltip, progress: $p, title: $t, artist: $a, action_icon: $i, player: $pl, time: $ti}'
    else
        echo '{"text": "Pausado", "class": "stopped", "tooltip": "Música detenida"}'
    fi
}

# Lógica para mostrar carátula (usando notify-send)
if [[ "$1" == "--show-art" ]]; then
    data=$(get_data)
    [[ $(echo "$data" | jq -r '.class') == "stopped" ]] && exit 0
    
    title=$(echo "$data" | jq -r '.title')
    artist=$(echo "$data" | jq -r '.artist')
    player_name=$(echo "$data" | jq -r '.player')
    
    art_url=$(playerctl -p "$player_name" metadata mpris:artUrl 2>/dev/null)
    
    if [[ "$art_url" == http* ]]; then
        img_path="/tmp/music_art_waybar.png"
        curl -s "$art_url" --output "$img_path"
    elif [[ "$art_url" == file://* ]]; then
        img_path=$(echo "$art_url" | sed 's/file:\/\///')
    else
        img_path="audio-x-generic"
    fi

    notify-send -e -a "MusicPanel" -i "$img_path" "$title" "󰠃 $artist\n󰓇 $player_name" -t 3000
    exit 0
fi

# Salida continua para Waybar
while true; do
    get_data | jq -c '{text, class, tooltip}'
    sleep 1
done
