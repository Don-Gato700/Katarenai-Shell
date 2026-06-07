#!/bin/bash

# Colores para la terminal
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}🗑️  Desinstalador de Katarenai-Shell (語れない)${NC}"
echo -e "${CYAN}Este script eliminará la configuración actual para dejar Hyprland limpio.${NC}"
echo -e "¿Deseas proceder con la limpieza? (s/n)"
read -r response

if [[ ! "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    echo "Operación cancelada."
    exit 0
fi

echo -e "${CYAN}[1/5] Desactivando servicios y scripts en ejecución...${NC}"
# Detener el servicio orbit si existe
systemctl --user disable --now orbit 2>/dev/null
# Matar procesos de widgets activos
pkill -u "$USER" -x cava 2>/dev/null

echo -e "${CYAN}[2/5] Eliminando archivos de configuración de Katarenai...${NC}"
# Eliminamos los widgets y scripts específicos
rm -rf ~/.config/hypr/widgets

# Eliminamos las configuraciones de los componentes de la shell
rm -rf ~/.config/waybar
rm -rf ~/.config/swaync
rm -rf ~/.config/rofi

# Para dejar Hyprland "recién instalado", eliminamos los archivos .conf
# Hyprland generará una configuración por defecto con un aviso rojo al reiniciar
rm -f ~/.config/hypr/*.conf

echo -e "${CYAN}[3/5] Limpiando archivos temporales...${NC}"
rm -f /tmp/cava_config_waybar /tmp/cava_disabled

echo -e "${CYAN}[4/5] Limpiando assets (opcional)...${NC}"
# Solo eliminamos la subcarpeta del proyecto para no borrar otros wallpapers del usuario
rm -rf ~/Pictures/Wallpapers/Slashdog29 2>/dev/null

echo -e "${CYAN}[5/5] Finalizando...${NC}"

echo -e "${PURPLE}--------------------------------------------------${NC}"
echo -e "✅ ¡Limpieza completada!${NC}"
echo -e ""
echo -e "Nota: Los paquetes (hyprland, waybar, etc.) siguen instalados."
echo -e "Si quieres borrarlos físicamente del sistema, ejecuta:"
echo -e "sudo pacman -Rs waybar swaync rofi-wayland brightnessctl cava waypaper"
echo -e ""
echo -e "Al reiniciar Hyprland, verás la configuración básica de fábrica."
echo -e "${PURPLE}--------------------------------------------------${NC}"

# Preguntar si desea reiniciar Hyprland ahora
echo -e "¿Deseas cerrar la sesión de Hyprland ahora para aplicar los cambios? (s/n)"
read -r restart_now
if [[ "$restart_now" =~ ^([sS][iI]|[sS])$ ]]; then
    hyprctl dispatch exit
fi