# Estado del proyecto

Este documento resume el estado actual del proyecto **homelab-infrastructure**.

El objetivo es mantener una referencia simple del avance, la fase actual y el próximo paso recomendado.

---

## Roadmap general

El proyecto sigue este path:

```text
Fase 1 — Proxmox / Cloud-Init / templates
Fase 2 — GitHub como fuente de verdad
Fase 3 — Ansible local
Fase 4 — Monitoreo
Fase 5 — Red híbrida con Azure
Fase 6 — Backups híbridos
```

---

## Estado actual resumido

```text
Fase 1A — Proxmox base                   avanzada
Fase 1B — admin-01                       completada en base inicial
Fase 1C — Template Rocky Cloud-Init      fase actual
Fase 2  — GitHub / repositorio           iniciado, pendiente de formalizar completamente
Fase 3  — Ansible base                   completada en base inicial
Fase 4  — Monitoreo                      pendiente
Fase 5  — Red híbrida Azure              pendiente
Fase 6  — Backups Azure                  pendiente
```

---

## Fase actual

La fase actual del proyecto es:

```text
Fase 1C — Template Rocky Linux 9 con Cloud-Init
```

El objetivo de esta fase es dejar validada y documentada la plantilla oficial Rocky Linux 9 para crear nuevas VMs de forma repetible desde Proxmox.

---

## Template oficial

El template oficial actual es:

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

Este template es la base para clonar nuevas VMs Rocky Linux 9 del laboratorio.

---

## Nodo administrador

El nodo administrador actual es:

```text
admin-01
```

Función:

```text
Nodo desde donde se ejecuta Ansible y se administra la configuración base del homelab.
```

Usuario administrativo:

```text
jocufe
```

---

## Repositorio

El repositorio local del proyecto se encuentra en:

```text
~/homelab/homelab-infrastructure
```

Estructura principal actual:

```text
homelab-infrastructure/
├── ansible/
├── cloud-init/
├── diagrams/
├── docs/
├── scripts/
└── README.md
```

---

## Ansible

La base inicial de Ansible ya fue completada.

Se completó:

```text
estructura Ansible limpia
inventario funcional
roles base creados
documentación Ansible creada
validaciones compactas correctas
ejecución de site.yml aplicada correctamente
commit de cierre realizado
```

Playbook principal:

```text
ansible/playbooks/site.yml
```

Ejecución general:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

Roles actuales:

```text
base
users
ssh_hardening
firewall
system_update
```

Documentación Ansible:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

---

## Proxmox / Cloud-Init

Documentación relacionada con el template Rocky Linux 9:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
docs/vm-inventory.md
```

Script relacionado con clonación de VMs:

```text
scripts/clone-rocky9-vm.sh
```

El script debe usar como base:

```text
TEMPLATE_ID=200
```

La carpeta:

```text
cloud-init/
```

queda reservada para archivos de Cloud-Init personalizados en fases posteriores. Actualmente la configuración base se gestiona desde Proxmox con opciones como `ciuser`, `sshkeys` e `ipconfig0`.

---

## Validaciones realizadas

Validaciones Ansible realizadas correctamente:

```bash
ansible --version | grep "config file"
ansible-playbook playbooks/site.yml --syntax-check
ansible-playbook playbooks/site.yml --list-tasks
ansible-playbook playbooks/site.yml -K
```

Validaciones documentadas del template Rocky Linux 9:

```text
Cloud-Init aplicado
usuario jocufe configurado
SSH por llave validado
DHCP funcionando
QEMU Guest Agent habilitado
clonado desde template probado
hostname aplicado en clon
```

---

## Próximo paso recomendado

El próximo paso recomendado es cerrar la fase del template oficial:

```text
Fase 1C — Template Rocky Linux 9 con Cloud-Init
```

Acciones inmediatas:

```text
1. Confirmar que la documentación usa VMID 200 como template oficial.
2. Confirmar que no quedan referencias incorrectas a templates no oficiales.
3. Revisar que scripts/clone-rocky9-vm.sh use TEMPLATE_ID=200.
4. Validar el script de clonación con una VM de prueba si corresponde.
5. Actualizar docs/vm-inventory.md con el estado real de las VMs.
6. Hacer commit de cierre de la fase del template.
```

---

## Fuera del alcance por ahora

No abrir todavía:

```text
Monitoreo con Prometheus/Grafana
Red híbrida con Azure
Backups híbridos hacia Azure
Hardening avanzado
Automatización avanzada de creación de VMs
```

También queda fuera del alcance crear tags únicos para ejecutar tareas individuales. Esa fue una duda puntual y no forma parte del roadmap inmediato.

---

## Nota de enfoque

El proyecto debe avanzar por fases, evitando desviaciones y evitando agregar mejoras no solicitadas.

Antes de abrir una fase nueva, se debe cerrar el bloque actual con documentación mínima y validación funcional.
