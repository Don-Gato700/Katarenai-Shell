#!/bin/bash

# Colores para la terminal (Estética Desert-Punk)
SAND='\033[0;33m'
NEON_PINK='\033[0;35m'
NEON_CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${NEON_PINK} Desert-Punk Oasis: Iniciando la instalación de Katarenai-Shell (語れない)...${NC}"
echo -e "${SAND}Preparando el entorno digital para Hyprland...${NC}"

# 1. Actualizar el sistema e instalar dependencias principales
echo -e "${NEON_CYAN}[1/6] Instalando paquetes base y dependencias...${NC}"
sudo pacman -S --needed \
    hyprland \
    waybar \
    swww \
    swaync \
    rofi-wayland \
    grim \
    slurp \
    wl-clipboard \
    brightnessctl \
    power-profiles-daemon \
    cava \
    ttf-jetbrains-mono-nerd \
    noto-fonts-emoji \
    pavucontrol \
    libpulse \
    networkmanager \
    sed \
    awk

# Intentar instalar waypaper desde el AUR si hay un helper disponible
AUR_HELPER=""
if command -v yay &> /dev/null; then AUR_HELPER="yay"; elif command -v paru &> /dev/null; then AUR_HELPER="paru"; fi

if [ -n "$AUR_HELPER" ]; then
    echo -e "${NEON_CYAN}Instalando waypaper desde el AUR usando $AUR_HELPER...${NC}"
    $AUR_HELPER -S --needed waypaper
else
    echo -e "${SAND}Aviso: No se encontró un AUR helper (yay/paru). Instala 'waypaper' manualmente.${NC}"
fi

# 2. Crear estructura de directorios en .config
echo -e "${NEON_CYAN}[2/6] Creando carpetas de configuración...${NC}"
mkdir -p ~/.config/hypr/widgets
mkdir -p ~/.config/waybar
mkdir -p ~/.config/swaync
mkdir -p ~/Pictures/Screenshots

# 3. Copiar archivos de configuración desde el repositorio
echo -e "${NEON_CYAN}[3/6] Desplegando archivos de Katarenai-Shell...${NC}"
echo -e "${SAND}¿Deseas reemplazar tu configuración actual en ~/.config? (s/n)${NC}"
read -r response

if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    # Hyprland (Configuraciones y estilos) - Usando -f para forzar reemplazo
    cp -f ./hypr/*.conf ~/.config/hypr/ 2>/dev/null
    cp -f ./hypr/style.css ~/.config/swaync/style.css 2>/dev/null

    # Waybar
    cp -rf ./waybar/* ~/.config/waybar/ 2>/dev/null

    # Widgets y Scripts
    cp -rf ./hypr/widgets/* ~/.config/hypr/widgets/ 2>/dev/null
    echo -e "${NEON_CYAN}Archivos reemplazados correctamente.${NC}"
else
    echo -e "${SAND}Se ha saltado la copia de archivos para proteger tu configuración actual.${NC}"
fi

# 4. Ingeniería de Calidad: Ajustar rutas dinámicamente
echo -e "${NEON_CYAN}[4/6] Adaptando rutas para el usuario actual ($USER)...${NC}"
# Reemplaza las rutas hardcodeadas /home/gato por el $HOME real del usuario
find ~/.config/hypr ~/.config/waybar ~/.config/swaync -type f -exec sed -i "s|/home/gato|$HOME|g" {} + 2>/dev/null

# 5. Habilitar servicios necesarios
echo -e "${NEON_CYAN}[5/6] Habilitando servicios de energía...${NC}"
sudo systemctl enable --now power-profiles-daemon.service

# 6. Configurar permisos de los scripts de la shell
echo -e "${NEON_CYAN}[6/6] Otorgando permisos de ejecución a los widgets...${NC}"
find ~/.config/hypr/widgets -type f -name "*.sh" -exec chmod +x {} + 2>/dev/null

echo -e "${NEON_PINK}--------------------------------------------------${NC}"
echo -e "${NEON_PINK}Instalación completada con éxito.${NC}"
echo -e "${SAND}Reinicia Hyprland o ejecuta 'waybar &' para ver los cambios.${NC}"
echo -e "${NEON_CYAN}¡Disfruta de tu nuevo oasis digital!${NC}"
echo -e "${NEON_PINK}--------------------------------------------------${NC}"