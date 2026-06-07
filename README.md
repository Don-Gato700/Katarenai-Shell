# 💜 Katarenai-Shell (語れない) — Dotfiles Elegantes en Tonos Morados para Hyprland

Bienvenido a **Katarenai-Shell**, un entorno de escritorio minimalista y atmosférico diseñado para **Arch Linux** sobre **Hyprland**. Este sistema apuesta por una estética visual profunda basada en transparencias, desenfoques (blur) y una paleta de colores centrada en el **morado y violetas oscuros**.

---

## 📦 ¿Qué hay dentro? (The Dots)

*   **Katarenai-Shell:** Una interfaz de usuario fragmentada basada en **Waybar** y **SwayNC**.
*   **Configuraciones de Hyprland:** Atajos de teclado, animaciones suaves y gestión de ventanas eficiente.
*   **Estilo Visual:** Archivos CSS personalizados para un look coherente entre notificaciones, barras y widgets.
*   **Orbit Integration:** Gestión de redes integrada mediante `orbit-wifi`.

---

## 🎨 Concepto de Diseño

*   **La Paleta:** Basada en el contraste entre el morado profundo (`#6a1b9a`), el violeta (`#c77dff`) y fondos oscuros semitransparentes.
*   **La Geometría:** Bordes redondeados y suaves (`border-radius: 15px - 20px`) que dan una sensación moderna y orgánica.
*   **Efectos:** Uso intensivo de `backdrop-filter: blur` para lograr un efecto de cristal esmerilado en todos los paneles.

---

## 🐚 La Arquitectura de Katarenai-Shell

La shell utiliza componentes flotantes para maximizar la visibilidad del fondo de pantalla:

### 1. La Barra Tótem (Panel Lateral Izquierdo)
*   **Indicador de Espacios de Trabajo (Workspaces):** Un Pacman.

### 2. El Menú (Lanzador Rofi)
Un lanzador de aplicaciones minimalista adaptado a la paleta morada del sistema.

### 3. Centro de Notificaciones (SwayNC)
Un panel lateral elegante que gestiona notificaciones y controles multimedia, utilizando un fondo morado ultra oscuro con alta transparencia.

---

## 🛠️ Herramientas Integradas

*   **OSD (On-Screen Display):** Scripts personalizados para volumen y brillo con barras de progreso integradas en las notificaciones.
*   **Media Player:** Widget con soporte para carátulas de álbumes y control de reproducción.
*   **Cava Toggle:** Script para activar/desactivar el visualizador de audio y ahorrar recursos.
*   **Wallpaper Selector:** Selector integrado con Rofi para cambiar el fondo dinámicamente.

## 🚀 Instalación (Arch Linux)

El despliegue está automatizado para sistemas Arch Linux. Asegúrate de tener un helper de AUR como `yay` o `paru` instalado.

```bash
git clone https://github.com/tu-usuario/Katarenai-Shell.git
cd Katarenai-Shell
chmod +x install.sh
./install.sh
```

### Dependencias Clave:
*   **WM:** Hyprland
*   **Barra:** Waybar
*   **Notificaciones:** SwayNC
*   **Red:** Orbit-Wifi (AUR)
