# Rocky Linux 9 Cloud-Init Template

## Resumen

Plantilla base de Rocky Linux 9 creada en Proxmox VE usando una imagen genérica de nube y Cloud-Init.

Esta plantilla permite crear nuevas máquinas virtuales rápidamente con usuario, llaves SSH, DHCP y QEMU Guest Agent preconfigurados.

## Configuración Proxmox

| Parámetro | Valor |
|---|---|
| VMID | 200 |
| Nombre | rocky9-cloud-template |
| Tipo | Template |
| CPU | host |
| Cores | 1 |
| Memoria | 1024 MB |
| Disco | 10 GB |
| Storage | local-lvm |
| Bus de disco | SCSI |
| Controlador SCSI | virtio-scsi-single |
| Red | virtio |
| Bridge | vmbr0 |
| Cloud-Init Drive | ide2 |
| IP | DHCP |
| Usuario Cloud-Init | jocufe |
| QEMU Guest Agent | enabled |

## Configuración validada

La configuración final del template incluye:

    agent: enabled=1
    boot: order=scsi0
    ciuser: jocufe
    cores: 1
    cpu: host
    ide2: local-lvm:vm-200-cloudinit,media=cdrom
    ipconfig0: ip=dhcp
    memory: 1024
    name: rocky9-cloud-template
    net0: virtio,bridge=vmbr0
    scsi0: local-lvm:base-200-disk-0,size=10G
    scsihw: virtio-scsi-single
    template: 1

## Validaciones realizadas

Se validó que QEMU Guest Agent responde correctamente desde Proxmox:

    qm agent 200 ping

Resultado esperado:

    Sin salida y regreso al prompt.

También se validó que Proxmox puede leer las interfaces internas de red de la VM:

    qm guest cmd 200 network-get-interfaces

Resultado validado:

    Interfaz eth0 detectada.
    Dirección IPv4 recibida por DHCP.
    QEMU Guest Agent funcionando correctamente.

## Prueba de clonación

Se creó un clon de prueba desde el template:

    qm clone 200 201 --name rocky9-test-01 --full true

Luego se inició el clon:

    qm start 201

Validaciones del clon:

- Arranque correcto.
- DHCP correcto.
- SSH correcto.
- Hostname aplicado correctamente.
- QEMU Guest Agent funcional.
- Cloud-Init aplicado correctamente.

Hostname validado dentro del clon:

    rocky9-test-01

El clon de prueba fue eliminado después de validar el template.

## Estado final

Template listo para ser usado como base de nuevas VMs Rocky Linux 9 en el laboratorio.

## Conclusión

La Fase 1A queda completada.

El laboratorio ya cuenta con una plantilla base reutilizable para crear servidores Linux de forma rápida, repetible y administrable desde Proxmox.
