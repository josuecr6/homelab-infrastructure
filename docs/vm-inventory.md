# VM Inventory

Inventario inicial de máquinas virtuales del laboratorio Proxmox.

## Templates

| VMID | Nombre | Sistema | Estado | Uso |
|---|---|---|---|---|
| 200 | rocky9-cloud-template | Rocky Linux 9 | Template | Plantilla base Cloud-Init |

## Virtual Machines

| VMID | Nombre | IP | Sistema | Estado | Rol |
|---|---|---|---|---|---|
| 201 | admin-01 | 192.168.0.201 | Rocky Linux 9 | Running | VM administrativa inicial |

## Notas

La VM `admin-01` fue creada usando el script:

    scripts/clone-rocky9-vm.sh

Comando utilizado:

    ./scripts/clone-rocky9-vm.sh 201 admin-01

Validaciones realizadas:

- Arranque correcto.
- DHCP correcto.
- SSH correcto.
- Hostname correcto.
- QEMU Guest Agent correcto.

## Corrección de Machine ID

Durante la validación de la VM `rocky9-admin-01`, se detectó que el `machine-id` había sido heredado desde el template original.

Se corrigió generando un nuevo identificador único dentro de la VM:

    sudo cp /etc/machine-id /etc/machine-id.bak
    sudo truncate -s 0 /etc/machine-id
    sudo systemd-machine-id-setup

Validación:

    hostnamectl

Resultado:

    La VM `rocky9-admin-01` ahora tiene un Machine ID único.
