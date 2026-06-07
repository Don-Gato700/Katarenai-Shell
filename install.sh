#!/bin/bash

# Colores para la terminal (Estética Purple/Neon)
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
VIOLET='\033[1;35m'
NC='\033[0m' # No Color

# --- Funciones de Instalación ---

install_deps() {
    echo -e "${CYAN}[1/6] Verificando sistema e instalando dependencias (Arch Linux)...${NC}"
    
    if [ ! -f /etc/arch-release ]; then
        echo -e "${PURPLE}Error: Este script está optimizado solo para Arch Linux.${NC}"
        exit 1
    fi

    # Instalación de paquetes base desde repositorios oficiales
    sudo pacman -S --needed --noconfirm \
        hyprland waybar swww swaync rofi-wayland \
        grim slurp wl-clipboard brightnessctl \
        power-profiles-daemon cava ttf-jetbrains-mono-nerd \
        noto-fonts-emoji pavucontrol libpulse \
        networkmanager sed awk acpi git base-devel

    # Instalación de dependencias críticas desde AUR (waypaper y quickshell)
    AUR_HELPER=$(command -v yay || command -v paru)
    if [ -n "$AUR_HELPER" ]; then
        echo -e "${CYAN}Instalando componentes adicionales desde AUR ($AUR_HELPER)...${NC}"
        $AUR_HELPER -S --needed --noconfirm waypaper orbit-wifi
    else
        echo -e "${PURPLE}Aviso: No se detectó yay/paru. Instala manualmente 'waypaper'.${NC}"
    fi
}

deploy_configs() {
    echo -e "${CYAN}[2/6] Desplegando archivos de configuración...${NC}"
    mkdir -p ~/.config/hypr/widgets ~/.config/waybar ~/.config/swaync ~/.config/rofi/assets
    
    cp -f ./hypr/*.conf ~/.config/hypr/ 2>/dev/null
    cp -rf ./hypr/widgets/* ~/.config/hypr/widgets/ 2>/dev/null
    cp -rf ./waybar/* ~/.config/waybar/ 2>/dev/null
    cp -rf ./rofi/* ~/.config/rofi/ 2>/dev/null
    
    # Ajustar rutas de home para el usuario actual
    find ~/.config/hypr ~/.config/waybar ~/.config/rofi -type f -exec sed -i "s|/home/[^/]*|$HOME|g" {} + 2>/dev/null
}

deploy_assets() {
    echo -e "${CYAN}[3/6] Configurando imágenes e iconos...${NC}"
    
    # Wallpapers - Clonando repositorio externo solicitado
    WP_DIR="$HOME/Pictures/Wallpapers/Slashdog29"
    mkdir -p "$HOME/Pictures/Wallpapers"
    if [ ! -d "$WP_DIR" ]; then
        echo -e "${CYAN}Clonando repositorio de wallpapers (Slashdog29)...${NC}"
        git clone --depth 1 https://github.com/Slashdog29/wallparpers-ramdon "$WP_DIR"
    else
        echo -e "${CYAN}El repositorio de wallpapers ya existe, actualizando...${NC}"
        git -C "$WP_DIR" pull
    fi

    # Iconos
    mkdir -p ~/.local/share/icons
    if [ -d "./assets/icons" ]; then
        cp -rf ./assets/icons/* ~/.local/share/icons/
    fi

    # Intentar aplicar el primer wallpaper si swww está corriendo
    if pgrep -x "swww-daemon" > /dev/null; then
        WP=$(find "$WP_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | head -n 1)
        [ -n "$WP" ] && swww img "$WP" --transition-type center
    fi
}

setup_user_services() {
    echo -e "${CYAN}[4/6] Configurando servicios de usuario (systemd)...${NC}"
    mkdir -p ~/.config/systemd/user/
    
    systemctl --user daemon-reload
    systemctl --user enable --now orbit
}

finalize_permissions() {
    echo -e "${CYAN}[5/6] Ajustando permisos de ejecución...${NC}"
    find ~/.config/hypr/widgets -type f -name "*.sh" -exec chmod +x {} +
    
    echo -e "${CYAN}[6/6] Habilitando servicios de sistema...${NC}"
    sudo systemctl enable --now power-profiles-daemon.service
}

# --- Flujo Principal ---

if [ ! -f "install.sh" ]; then
    echo -e "${PURPLE}Error: Ejecuta el script desde la raíz del repositorio.${NC}"
    exit 1
fi

echo -e "${VIOLET} Katarenai-Shell (語れない) ${NC}"
echo -e "${NC}Este script configurará tu entorno Hyprland con el tema Purple-Night.${NC}"
echo -e "${CYAN}¿Deseas proceder con la instalación? (s/n)${NC}"
read -r response

if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    install_deps
    deploy_configs
    deploy_assets
    setup_user_services
    finalize_permissions
    
    echo -e "${VIOLET}--------------------------------------------------${NC}"
    echo -e "¡Instalación completada! Reinicia Hyprland para aplicar.${NC}"
    echo -e "${VIOLET}--------------------------------------------------${NC}"
else
    echo -e "Instalación cancelada.${NC}"
    exit 0
fi