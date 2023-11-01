#!/bin/bash

# Archivo temporal para almacenar el estado
STATUS_FILE="/tmp/mouse_toggle_status"

if [ -f "$STATUS_FILE" ]; then
    # Si el archivo existe, suelta el botón y elimina el archivo
    xdotool mouseup 1
    rm -f "$STATUS_FILE"
else
    # Si el archivo no existe, presiona el botón y crea el archivo
    xdotool mousedown 1
    touch "$STATUS_FILE"
fi
