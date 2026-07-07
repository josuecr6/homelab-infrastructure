# Build Rocky Linux 9 Cloud-Init Template

## Objetivo

Construir una plantilla base de Rocky Linux 9 en Proxmox VE usando una imagen genérica de nube.

Esta plantilla permite crear máquinas virtuales rápidamente con:

- Usuario preconfigurado.
- Acceso SSH por llave pública.
- Red por DHCP.
- QEMU Guest Agent habilitado.
- Cloud-Init listo para clones.
- Machine ID limpio para evitar identidades duplicadas.

## Requisitos previos

- Proxmox VE instalado y funcionando.
- Imagen cloud de Rocky Linux 9 descargada en Proxmox.
- Archivo de llaves públicas SSH disponible en Proxmox.
- Storage `local-lvm` disponible.
- Bridge de red `vmbr0` disponible.

## Variables usadas

| Variable | Valor |
|---|---|
| VMID | 200 |
| Nombre | rocky9-cloud-template |
| Imagen | Rocky-9-GenericCloud.latest.x86_64.qcow2 |
| Storage | local-lvm |
| Bridge | vmbr0 |
| Usuario Cloud-Init | jocufe |

## Ruta de la imagen

    /var/lib/vz/template/iso/Rocky-9-GenericCloud.latest.x86_64.qcow2

## Ruta de llaves SSH

    /root/cloudinit-keys.pub

## Paso 1 - Crear definición de la VM

    qm create 200 \
      --name rocky9-cloud-template \
      --memory 1024 \
      --cores 1 \
      --cpu host \
      --net0 virtio,bridge=vmbr0

## Paso 2 - Importar disco cloud image

    qm importdisk 200 \
      /var/lib/vz/template/iso/Rocky-9-GenericCloud.latest.x86_64.qcow2 \
      local-lvm

El comando anterior crea un disco en `local-lvm`, normalmente con un nombre como:

    local-lvm:vm-200-disk-0

## Paso 3 - Conectar disco y Cloud-Init

    qm set 200 \
      --scsihw virtio-scsi-single \
      --scsi0 local-lvm:vm-200-disk-0 \
      --ide2 local-lvm:cloudinit \
      --boot order=scsi0

## Paso 4 - Configurar Cloud-Init

    qm set 200 \
      --ciuser jocufe \
      --sshkeys /root/cloudinit-keys.pub \
      --ipconfig0 ip=dhcp

## Paso 5 - Habilitar QEMU Guest Agent

    qm set 200 --agent enabled=1

## Paso 6 - Arrancar la VM para validación

    qm start 200

## Paso 7 - Obtener IP desde Proxmox

    qm guest cmd 200 network-get-interfaces

Buscar la dirección IPv4 asignada a la interfaz `eth0`.

## Paso 8 - Acceder por SSH

    ssh jocufe@<IP_DE_LA_VM>

## Paso 9 - Validar sistema operativo

Dentro de la VM:

    hostnamectl

## Paso 10 - Validar QEMU Guest Agent

Desde Proxmox:

    qm agent 200 ping

Resultado esperado:

    Sin salida y regreso al prompt.

También se puede validar con:

    qm guest cmd 200 network-get-interfaces

## Paso 11 - Limpiar Machine ID

Dentro de la VM:
    
    sudo truncate -s 0 /etc/machine-id

No se debe regenerar el `machine-id` dentro del template.

El objetivo es que cada clon genere su propio identificador único al iniciar.

## Paso 12 - Limpiar Cloud-Init

Dentro de la VM:

    sudo cloud-init clean --logs --seed

## Paso 13 - Apagar la VM

Dentro de la VM:

    sudo poweroff

Desde Proxmox validar:

    qm status 200

Resultado esperado:

    status: stopped

## Paso 14 - Convertir en template

Desde Proxmox:

    qm template 200

Validar:

    qm config 200 | grep template

Resultado esperado:

    template: 1

## Paso 15 - Probar el template

Crear un clon de prueba:

    qm clone 200 201 --name rocky9-template-test --full true

Arrancar el clon:

    qm start 201

Obtener IP:

    qm guest cmd 201 network-get-interfaces

Entrar por SSH:

    ssh jocufe@<IP_DEL_CLON>

Validar hostname:

    hostname

Validar Machine ID:

    cat /etc/machine-id

El `machine-id` debe ser diferente al de otros clones.

## Paso 16 - Eliminar clon de prueba

Desde Proxmox:

    qm shutdown 201
    qm destroy 201

## Resultado final

Template Rocky Linux 9 listo para usarse como base de nuevas VMs en Proxmox.

## Notas de ingeniería

- `qm create` crea la definición de la VM.
- `qm importdisk` importa el disco desde la imagen cloud.
- `qm set --scsi0` conecta el disco importado.
- `qm set --ide2 local-lvm:cloudinit` agrega el dispositivo Cloud-Init.
- `cloud-init clean` limpia el estado previo de inicialización.
- `/etc/machine-id` debe quedar vacío en el template para evitar identidades duplicadas.
- QEMU Guest Agent permite que Proxmox consulte información interna de la VM.
