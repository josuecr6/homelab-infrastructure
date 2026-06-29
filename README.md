# Homelab Infrastructure

Laboratorio personal de infraestructura híbrida usando Proxmox VE, Cloud-Init, GitHub, Ansible y Microsoft Azure.

## Objetivo

Construir una nube privada local sobre Proxmox VE y conectarla progresivamente con servicios de nube pública en Azure, aplicando prácticas de infraestructura como código, automatización, documentación técnica y administración segura.

## Fase actual

### Fase 1A - Template Rocky Linux 9 con Cloud-Init

Estado: completado.

Se creó una plantilla base en Proxmox usando Rocky Linux 9 Generic Cloud Image.

## Template base

| Campo | Valor |
|---|---|
| VMID | 200 |
| Nombre | rocky9-cloud-template |
| Sistema operativo | Rocky Linux 9 |
| Tipo | Proxmox Template |
| CPU | 1 core |
| RAM | 1024 MB |
| Disco | 10 GB |
| Storage | local-lvm |
| Controlador SCSI | virtio-scsi-single |
| Red | virtio sobre vmbr0 |
| IP | DHCP |
| Usuario Cloud-Init | jocufe |
| SSH Keys | configuradas |
| QEMU Guest Agent | habilitado |
| Cloud-Init | habilitado |

## Validaciones completadas

- Cloud-Init aplicado correctamente.
- Usuario SSH creado correctamente.
- Acceso SSH por llave validado.
- DHCP funcionando.
- QEMU Guest Agent funcionando.
- Clonado desde template probado exitosamente.
- Hostname aplicado correctamente en el clon.
- Template final limpio y validado.

## Próximas fases

1. Crear documentación técnica del template.
2. Crear scripts para clonar VMs desde la plantilla.
3. Introducir Ansible para configuración automática.
4. Agregar monitoreo con Prometheus y Grafana.
5. Integrar conectividad híbrida con Azure.
6. Implementar respaldos hacia Azure Blob Storage.
