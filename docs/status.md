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
Fase 1B — admin-01                       avanzada
Fase 1C — Template Rocky Cloud-Init      pendiente de cerrar
Fase 2  — GitHub / repositorio           pendiente de formalizar
Fase 3  — Ansible base                   fase actual
Fase 4  — Monitoreo                      pendiente
Fase 5  — Red híbrida Azure              pendiente
Fase 6  — Backups Azure                  pendiente
```

---

## Fase actual

La fase actual del proyecto es:

```text
Fase 3 — Automatización local con Ansible
```

El objetivo de esta fase es dejar una base Ansible simple, funcional, documentada y repetible para administrar servidores Linux del laboratorio desde `admin-01`.

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

La estructura principal actual incluye:

```text
homelab-infrastructure/
├── ansible/
├── docs/
└── README.md
```

La estructura Ansible principal es:

```text
ansible/
├── ansible.cfg
├── inventory/
├── playbooks/
└── roles/
```

---

## Documentación completada

Documentación Ansible completada:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

Documentación relacionada con Proxmox / Rocky Cloud Template existente:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
docs/vm-inventory.md
```

---

## Playbook principal

El punto de entrada principal de Ansible es:

```text
ansible/playbooks/site.yml
```

Ejecución desde el directorio `ansible/`:

```bash
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

---

## Roles actuales

Roles Ansible actuales:

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
users            Usuario administrativo, SSH key y sudoers
ssh_hardening    Endurecimiento básico de SSH
firewall         firewalld y servicios permitidos
system_update    Actualización de paquetes del sistema
```

---

## Validaciones realizadas

Validaciones compactas realizadas sobre Ansible:

```bash
ansible --version | grep "config file"
ansible-playbook playbooks/site.yml --syntax-check
ansible-playbook playbooks/site.yml --list-tasks
```

Estado reportado:

```text
Sin errores conocidos al momento de documentar este estado.
```

---

## Próximo paso recomendado

El próximo paso recomendado es cerrar la ejecución final de la base Ansible:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

Después de una ejecución exitosa, la Fase 3 puede considerarse cerrada en su base inicial.

---

## Siguiente fase después de Ansible

Después de cerrar la base Ansible, se debe regresar a:

```text
Fase 1C — Template Rocky Linux 9 con Cloud-Init
```

Pendiente de cerrar:

```text
Cloud-Init funcionando
usuario jocufe configurado
llave SSH funcionando
DHCP funcionando
QEMU Guest Agent funcionando
clonado de VMs probado
documentación del proceso actualizada
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

También queda fuera del alcance actual crear tags únicos para ejecutar tareas individuales. Esa fue una duda puntual y no forma parte del roadmap inmediato.

---

## Nota de enfoque

El proyecto debe avanzar por fases, evitando desviaciones y evitando agregar mejoras no solicitadas.

Antes de abrir una fase nueva, se debe cerrar el bloque actual con documentación mínima y validación funcional.
