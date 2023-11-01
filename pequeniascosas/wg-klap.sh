#!/bin/bash

# Colores
ROJO="\033[1;31m"
DORADO="\033[1;33m"
AZUL="\033[1;34m"
NC="\033[0m" # Sin color

CONFIG_PATH="/etc/wireguard"
echo -e "${DORADO}Archivos de configuración disponibles en $CONFIG_PATH:${NC}"

# Listar archivos de configuración
FILES=($(ls $CONFIG_PATH/*.conf))
for i in "${!FILES[@]}"; do 
  echo -e "${ROJO}$i)${NC} ${FILES[$i]}"
done

echo -e "${ROJO}$((${#FILES[@]}))${NC}) Desconectar de WireGuard"

# Elegir una configuración
echo -e "${AZUL}Por favor, elige un número para la conexión (o 'salir' para cancelar):${NC}"
read INPUT

if [[ $INPUT =~ ^[0-9]+$ ]]; then
  if [ "$INPUT" -ge 0 ] && [ "$INPUT" -lt "${#FILES[@]}" ]; then
    # Conectar usando la configuración seleccionada
    SELECTED_CONFIG=${FILES[$INPUT]}
    echo -e "${DORADO}Conectando usando $SELECTED_CONFIG ...${NC}"
    sudo wg-quick up "${SELECTED_CONFIG}"
    echo -e "${AZUL}Conectado a $(basename "$SELECTED_CONFIG")${NC}"
  elif [ "$INPUT" -eq "${#FILES[@]}" ]; then
    # Desconectar de WireGuard
    echo -e "${DORADO}Conexiones activas de WireGuard:${NC}"
    wg show | grep interface | awk '{print $2}'
    echo -e "${AZUL}Introduce el nombre de la conexión para desconectar:${NC}"
    read WG_INTERFACE
    if [ -n "$WG_INTERFACE" ]; then
      sudo wg-quick down "$WG_INTERFACE"
      echo -e "${AZUL}Desconectado de $WG_INTERFACE${NC}"
    else
      echo -e "${ROJO}No se proporcionó ninguna conexión.${NC}"
    fi
  else
    echo -e "${ROJO}Selección no válida.${NC}"
  fi
else
  echo -e "${ROJO}Comando cancelado o selección no válida.${NC}"
fi

echo -e "${AZUL}Powered by GPT & Klap${NC}"
