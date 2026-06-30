# VM Inventory

Inventario inicial de máquinas virtuales del laboratorio Proxmox.

## Templates

| VMID | Nombre | Sistema | Estado | Uso |
|---|---|---|---|---|
| 200 | rocky9-cloud-template | Rocky Linux 9 | Template | Plantilla base Cloud-Init |

## Virtual Machines

| VMID | Nombre | IP | Sistema | Estado | Rol |
|---|---|---|---|---|---|
| 210 | rocky9-admin-01 | 192.168.0.195 | Rocky Linux 9 | Running | VM administrativa inicial |

## Notas

La VM `rocky9-admin-01` fue creada usando el script:

    scripts/clone-rocky9-vm.sh

Comando utilizado:

    ./scripts/clone-rocky9-vm.sh 210 rocky9-admin-01

Validaciones realizadas:

- Arranque correcto.
- DHCP correcto.
- SSH correcto.
- Hostname correcto.
- QEMU Guest Agent correcto.
