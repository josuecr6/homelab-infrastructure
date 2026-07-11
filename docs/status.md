# Estado del proyecto

Este documento resume el estado actual del proyecto **homelab-infrastructure** y mantiene una referencia simple del avance, la fase siguiente y los pendientes.

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
Fase 4 — Monitoreo / Observabilidad           completada en alcance básico
Fase 5 — Red híbrida con Azure                pendiente
Fase 6 — Backups híbridos                     pendiente
```

La próxima fase del roadmap es:

```text
Fase 5 — Red híbrida con Azure
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

### Nodo de monitoreo

```text
VMID: 202
Nombre: monitor-01
IP: 192.168.0.202
Sistema operativo: Rocky Linux 9
Usuario administrativo: jocufe
Rol: Prometheus + Grafana + Node Exporter
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

Estado:

```text
Git actualizado y sincronizado
Repositorio usado como fuente de verdad del proyecto
```

---

## Ansible

La base inicial de Ansible está completada y administra los hosts principales del homelab.

Directorio principal:

```text
~/homelab/homelab-infrastructure/ansible
```

Archivos principales:

```text
ansible/ansible.cfg
ansible/inventory/hosts.ini
ansible/inventory/group_vars/all/main.yml
ansible/playbooks/site.yml
```

Roles actuales:

```text
base
users
ssh_hardening
firewall
system_update
node_exporter
prometheus
grafana
```

Ejecución general:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

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

