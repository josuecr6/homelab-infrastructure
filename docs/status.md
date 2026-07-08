# Estado del proyecto

Este documento resume el estado actual del proyecto **homelab-infrastructure**.

Su objetivo es mantener una referencia simple del avance, la fase actual y los próximos pasos del proyecto.

---

## Roadmap general

```text
Fase 1 — Proxmox / Cloud-Init / templates
Fase 2 — GitHub como fuente de verdad
Fase 3 — Ansible local
Fase 4 — Monitoreo / Observabilidad
Fase 5 — Red híbrida con Azure
Fase 6 — Backups híbridos
```

---

## Estado actual resumido

```text
Fase 1 — Proxmox / Cloud-Init / templates     completada en base inicial
Fase 2 — GitHub como fuente de verdad         completada en base inicial
Fase 3 — Ansible local                        completada en base inicial
Fase 4 — Monitoreo / Observabilidad           en inicio
Fase 5 — Red híbrida con Azure                pendiente
Fase 6 — Backups híbridos                     pendiente
```

---

## Fase actual

La fase actual del proyecto es:

```text
Fase 4 — Monitoreo / Observabilidad
```

Objetivo inicial:

```text
Implementar una capa básica de monitoreo para observar el estado de las VMs principales del homelab.
```

Alcance inicial:

```text
Prometheus
Grafana
Node Exporter
Monitoreo básico de sistema
Documentación de arquitectura inicial
```

Fuera del alcance por ahora:

```text
Alertas avanzadas
Logs centralizados
Monitoreo profundo de Proxmox
Integración con Azure
Backups de métricas
```

---

## Infraestructura base actual

### Host Proxmox

```text
Hostname: rdaneel
IP: 192.168.0.99
Sistema: Proxmox VE
Bridge: vmbr0
Storage: local-lvm
```

### Template oficial Rocky Linux 9

```text
VMID: 200
Nombre: rocky9-cloud-template
Sistema operativo: Rocky Linux 9
Tipo: Proxmox Template
Cloud-Init: habilitado
QEMU Guest Agent: habilitado
Red: DHCP sobre vmbr0
Usuario Cloud-Init: jocufe
```

Este template es la base oficial para crear nuevas VMs Rocky Linux 9 del laboratorio.

### Nodo administrador

```text
VMID: 201
Nombre: admin-01
IP: 192.168.0.201
Sistema operativo: Rocky Linux 9
Usuario administrativo: jocufe
Rol: nodo administrador Ansible
```

---

## Repositorio

Repositorio local:

```text
~/homelab/homelab-infrastructure
```

Repositorio remoto:

```text
git@github.com:josuecr6/homelab-infrastructure.git
```

Estructura principal:

```text
homelab-infrastructure/
├── ansible/
├── cloud-init/
├── diagrams/
├── docs/
├── scripts/
└── README.md
```

Estado:

```text
Git actualizado y sincronizado
Repositorio usado como fuente de verdad del proyecto
```

---

## Ansible

La base inicial de Ansible está completada.

Directorio principal:

```text
~/homelab/homelab-infrastructure/ansible
```

Archivo de configuración:

```text
ansible/ansible.cfg
```

Inventario:

```text
ansible/inventory/hosts.ini
```

Variables globales:

```text
ansible/inventory/group_vars/all/main.yml
```

Playbook principal:

```text
ansible/playbooks/site.yml
```

Roles actuales:

```text
base
users
ssh_hardening
firewall
system_update
```

Ejecución general:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

Nota:

```text
-K = K MAYÚSCULA = contraseña de sudo / become
-k = k minúscula = contraseña SSH
```

Documentación Ansible:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

---

## Proxmox / Cloud-Init

Documentación relacionada:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
docs/vm-inventory.md
```

Script de clonación:

```text
scripts/clone-rocky9-vm.sh
```

El script debe usar como base:

```text
TEMPLATE_ID=200
```

Importante:

```text
El script de clonación debe ejecutarse desde el host Proxmox, no desde admin-01.
```

Motivo:

```text
El comando qm solo existe en Proxmox.
```

La carpeta:

```text
cloud-init/
```

queda reservada para configuraciones Cloud-Init personalizadas futuras.

---

## Monitoreo / Observabilidad

Estado:

```text
En inicio
```

Documentación inicial:

```text
docs/monitoring.md
```

Arquitectura propuesta:

```text
Proxmox host
   |
   |-- VM 201 admin-01
   |      |-- node_exporter
   |
   |-- VM 202 monitor-01
          |-- Prometheus
          |-- Grafana
          |-- node_exporter
```

VM propuesta para monitoreo:

```text
VMID: 202
Nombre: monitor-01
Sistema operativo: Rocky Linux 9
Base: template VMID 200
Rol: Prometheus + Grafana + Node Exporter
```

Servicios iniciales:

```text
Prometheus    puerto 9090
Grafana       puerto 3000
Node Exporter puerto 9100
```

Hosts iniciales a monitorear:

```text
monitor-01
admin-01
```

---

## Validaciones completadas

### Template Rocky Linux 9

```text
Template oficial VMID 200 validado
Cloud-Init aplicado
Usuario jocufe configurado
SSH por llave validado
DHCP funcionando
QEMU Guest Agent habilitado
Clonado desde template probado
Hostname aplicado en clon
admin-01 con machine-id único
```

### Ansible

```text
Inventario funcional
Conexión Ansible validada
Roles base creados
Variables globales organizadas
site.yml validado
site.yml aplicado correctamente
Documentación Ansible creada
```

Comandos usados:

```bash
ansible --version | grep "config file"
ansible-playbook playbooks/site.yml --syntax-check
ansible-playbook playbooks/site.yml --list-tasks
ansible-playbook playbooks/site.yml -K
```

---

## Próximo paso recomendado

Continuar con la Fase 4:

```text
Crear la VM monitor-01 desde el template oficial VMID 200.
```

Acciones inmediatas:

```text
1. Corregir docs/monitoring.md para usar VMID 202.
2. Confirmar cambios de documentación.
3. Hacer commit del inicio de Fase 4.
4. Crear monitor-01 desde Proxmox.
5. Agregar monitor-01 al inventario Ansible.
6. Preparar roles mínimos para Node Exporter, Prometheus y Grafana.
```

---

## Fuera del alcance por ahora

No abrir todavía:

```text
Red híbrida con Azure
Backups híbridos hacia Azure
Hardening avanzado
Automatización avanzada de creación de VMs
Alertas avanzadas
Logs centralizados
```

También queda fuera del alcance crear tags únicos para ejecutar tareas individuales. Esa fue una duda puntual y no forma parte del roadmap inmediato.

