#!/bin/bash

# Evitar ejecuciones simultáneas
LOCK_FILE="/tmp/system_optimize.lock"
if [ -f "$LOCK_FILE" ]; then
    notify-send -e -a "Sistema" "Optimización" "Ya hay una tarea en curso." -t 2000
    exit 1
fi
touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Enviar notificación de inicio
notify-send -e -a "Sistema" "Optimización" "Liberando memoria caché y sincronizando buffers..." -i "system-run-symbolic" -t 3000

# Sincronizar discos y limpiar caché de RAM (Requiere contraseña mediante popup de PolicyKit)
# Se usa sh -c para asegurar que toda la cadena de comandos se ejecute con privilegios
if pkexec sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"; then
    # Notificación final de éxito
    notify-send -e -a "Sistema" "Optimización" "¡Proceso completado con éxito!" -i "checkbox-checked-symbolic" -t 3000
else
    # Notificación si se cancela la autenticación o falla
    notify-send -e -u low -a "Sistema" "Optimización" "La optimización fue cancelada o falló." -i "dialog-error" -t 2000
fi