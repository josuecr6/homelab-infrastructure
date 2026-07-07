# Homelab Infrastructure

Repositorio de infraestructura para un laboratorio local/híbrido basado en Proxmox VE, Rocky Linux, Cloud-Init, Ansible, GitHub y Microsoft Azure.

El objetivo del proyecto es construir una base de infraestructura reproducible para crear, configurar, documentar y administrar servidores del homelab de forma ordenada y progresiva.

---

## Objetivo del proyecto

Este proyecto busca implementar una nube privada local sobre Proxmox VE y extenderla progresivamente hacia servicios de nube pública en Azure.

El enfoque principal es aprender y aplicar prácticas de:

- virtualización;
- infraestructura como código;
- automatización con Ansible;
- administración segura de servidores Linux;
- documentación técnica;
- control de versiones con Git;
- integración futura con servicios cloud.

---

## Roadmap general

El proyecto sigue este camino de trabajo:

```text
Fase 1 — Proxmox / Cloud-Init / templates
Fase 2 — GitHub como fuente de verdad
Fase 3 — Ansible local
Fase 4 — Monitoreo
Fase 5 — Red híbrida con Azure
Fase 6 — Backups híbridos
```

El estado detallado de cada fase se mantiene en:

```text
docs/status.md
```

---

## Estructura del repositorio

```text
homelab-infrastructure/
├── ansible/
├── cloud-init/
├── diagrams/
├── docs/
├── scripts/
└── README.md
```

Descripción general:

```text
ansible/      Automatización y configuración de hosts Linux
cloud-init/   Archivos relacionados con inicialización de VMs
diagrams/     Diagramas de arquitectura del laboratorio
docs/         Documentación técnica del proyecto
scripts/      Scripts auxiliares para tareas operativas
README.md     Entrada principal del repositorio
```

---

## Ansible

La configuración Ansible se encuentra en:

```text
ansible/
```

Estructura principal:

```text
ansible/
├── ansible.cfg
├── inventory/
├── playbooks/
└── roles/
```

El playbook principal es:

```text
ansible/playbooks/site.yml
```

Ejecución general desde `admin-01`:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

Documentación relacionada:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

---

## Nodo administrador

El nodo administrador actual del laboratorio es:

```text
admin-01
```

Este servidor se usa para:

- ejecutar Ansible;
- administrar inventarios;
- aplicar playbooks;
- mantener documentación operativa;
- gestionar tareas futuras de automatización.

Usuario administrativo principal:

```text
jocufe
```

---

## Proxmox y Cloud-Init

La documentación relacionada con la creación de templates Rocky Linux 9 y Cloud-Init se encuentra en:

```text
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
docs/vm-inventory.md
```

Los archivos específicos de Cloud-Init deben mantenerse en:

```text
cloud-init/
```

---

## Scripts

Los scripts auxiliares del proyecto se almacenan en:

```text
scripts/
```

Actualmente existe un script relacionado con la clonación de VMs Rocky Linux 9:

```text
scripts/clone-rocky9-vm.sh
```

---

## Documentación

Documentos principales:

```text
docs/status.md
docs/vm-inventory.md
docs/build-rocky9-cloud-template.md
docs/rocky9-cloud-template.md
```

Documentación de Ansible:

```text
docs/ansible/admin-01.md
docs/ansible/ansible-roles.md
docs/ansible/security-hardening.md
```

---

## Estado del proyecto

El estado detallado del proyecto, la fase actual y el próximo paso recomendado se documentan en:

```text
docs/status.md
```

El README solo mantiene una descripción general del repositorio y sus puntos de entrada principales.

---

## Alcance inmediato

El proyecto debe avanzar por fases.

No se deben abrir nuevas áreas como monitoreo, red híbrida o backups hasta cerrar los bloques anteriores correspondientes.

Las decisiones de avance, pendientes y próximos pasos deben quedar documentadas en:

```text
docs/status.md
```
