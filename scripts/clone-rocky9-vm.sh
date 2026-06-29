#!/bin/bash

set -e

TEMPLATE_ID=200

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <vmid> <nombre-vm>"
    echo "Ejemplo: $0 210 rocky9-web-01"
    exit 1
fi

NEW_VMID="$1"
NEW_NAME="$2"

echo "Creando VM ${NEW_NAME} con VMID ${NEW_VMID} desde template ${TEMPLATE_ID}..."

qm clone "${TEMPLATE_ID}" "${NEW_VMID}" --name "${NEW_NAME}" --full true

echo "Configurando Cloud-Init para DHCP..."
qm set "${NEW_VMID}" --ipconfig0 ip=dhcp

echo "Iniciando VM..."
qm start "${NEW_VMID}"

echo "VM creada e iniciada correctamente."
echo "Puedes consultar su IP con:"
echo "qm guest cmd ${NEW_VMID} network-get-interfaces"
