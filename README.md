# Homelab Infrastructure

Laboratorio personal de infraestructura local/híbrida usando Proxmox VE, Cloud-Init, GitHub, Ansible y Microsoft Azure.

El objetivo del proyecto es construir una nube privada local sobre Proxmox VE y conectarla progresivamente con servicios de nube pública en Azure, aplicando prácticas de infraestructura como código, automatización, documentación técnica y administración segura.

---

## Roadmap del proyecto

El proyecto sigue este path general:

```text
Fase 1 — Proxmox / Cloud-Init / templates
Fase 2 — GitHub como fuente de verdad
Fase 3 — Ansible local
Fase 4 — Monitoreo
Fase 5 — Red híbrida con Azure
Fase 6 — Backups híbridos
```

---

## Estado actual

La base inicial de Ansible quedó completada.

```text
Fase 3 — Automatización local con Ansible
Estado: base inicial completada
```

Se completó:

```text
Estructura Ansible limpia
Inventario funcional
Roles base creados
Documentación Ansible creada
Validaciones compactas correctas
Ejecución de site.yml aplicada correctamente
```

El siguiente paso inmediato es registrar los cambios en Git.

Después de guardar este cierre, el proyecto debe volver a:

```text
Fase 1C — Template Rocky Linux 9 con Cloud-Init
```

para cerrar y validar completamente la plantilla, QEMU Guest Agent y clonación de VMs.

---

## Estado por fases

```text
Fase 1A — Proxmox base                   avanzada
Fase 1B — admin-01                       avanzada
Fase 1C — Template Rocky Cloud-Init      pendiente de cerrar
Fase 2  — GitHub / repositorio           pendiente de formalizar
Fase 3  — Ansible base                   completada en base inicial
Fase 4  — Monitoreo                      pendiente
Fase 5  — Red híbrida Azure              pendiente
Fase 6  — Backups Azure                  pendiente
```

---

## Estructura del repositorio

```text
homelab-infrastructure/
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.ini
│   │   └── group_vars/
│   │       └── all/
│   │           └── main.yml
│   ├── playbooks/
│   │   ├── base-rocky.yml
│   │   ├── check-host.yml
│   │   ├── firewall.yml
│   │   ├── site.yml
│   │   ├── ssh-hardening.yml
│   │   ├── system-update.yml
│   │   └── users.yml
│   └── roles/
│       ├── base/
│       ├── firewall/
│       ├── ssh_hardening/
│       ├── system_update/
│       └── users/
├── cloud-init/
├── diagrams/
├── docs/
│   ├── ansible/
│   │   ├── admin-01.md
│   │   ├── ansible-roles.md
│   │   └── security-hardening.md
│   ├── build-rocky9-cloud-template.md
│   ├── rocky9-cloud-template.md
│   ├── status.md
│   └── vm-inventory.md
├── scripts/
│   └── clone-rocky9-vm.sh
└── README.md
```

---

## Nodo administrador

El nodo administrador actual es:

```text
admin-01
```

Función:

```text
Servidor desde donde se ejecuta Ansible y se administra la configuración base del homelab.
```

Usuario administrativo:

```text
jocufe
```

Repositorio local:

```text
~/homelab/homelab-infrastructure
```

---

## Ansible

La automatización local se encuentra en:

```text
ansible/
```

El archivo principal de configuración es:

```text
ansible/ansible.cfg
```

El inventario principal es:

```text
ansible/inventory/hosts.ini
```

Las variables globales están en:

```text
ansible/inventory/group_vars/all/main.yml
```

El playbook principal es:

```text
ansible/playbooks/site.yml
```

---

## Roles Ansible actuales

```text
base
users
ssh_hardening
firewall
system_update
```

Responsabilidades generales:

```text
base             Configuración base de Rocky Linux
users            Usuario administrativo, llave SSH y sudoers
ssh_hardening    Endurecimiento básico de SSH
firewall         firewalld y servicios permitidos
system_update    Actualización de paquetes del sistema
```

---

## Comandos principales de Ansible

Entrar al directorio de Ansible:

```bash
cd ~/homelab/homelab-infrastructure/ansible
```

Validar configuración usada por Ansible:

```bash
ansible --version | grep "config file"
```

Validar sintaxis:

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

Listar tareas:

```bash
ansible-playbook playbooks/site.yml --list-tasks
```

Ejecutar configuración completa:

```bash
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

---

## Documentación

Estado general del proyecto:

```text
docs/status.md
```

Documentación Ansible:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

Documentación Proxmox / Rocky Cloud Template:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
docs/vm-inventory.md
```

---

## Template Rocky Linux 9

La documentación del template Rocky Linux 9 se mantiene en:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
```

Esta parte pertenece a:

```text
Fase 1 — Proxmox / Cloud-Init / templates
```

Pendiente de cerrar en la siguiente etapa:

```text
Cloud-Init funcionando de forma repetible
usuario jocufe configurado
llave SSH funcionando
DHCP funcionando
QEMU Guest Agent funcionando
clonado de VMs probado
documentación actualizada
```

---

## Scripts

Actualmente existe:

```text
scripts/clone-rocky9-vm.sh
```

Este script pertenece al bloque de creación/clonado de VMs desde template y será revisado cuando se retome la fase del template Rocky Cloud-Init.

---

## Fuera del alcance inmediato

No abrir todavía:

```text
Monitoreo con Prometheus/Grafana
Red híbrida con Azure
Backups híbridos hacia Azure
Hardening avanzado
Automatización avanzada de VMs
```

El proyecto debe avanzar por fases y evitar agregar mejoras no solicitadas.
