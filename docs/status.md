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

```text
Local:  ~/homelab/homelab-infrastructure
Remoto: git@github.com:josuecr6/homelab-infrastructure.git
Rama:   main
Estado: Git actualizado y sincronizado
```

El repositorio se utiliza como fuente de verdad del proyecto.

---

## Ansible

La base inicial de Ansible está completada y administra los hosts principales del homelab.

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

Documentación relacionada:

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

El script usa el template oficial VMID 200 y debe ejecutarse desde el host Proxmox, donde está disponible el comando `qm`.

---

## Fase 4 — Monitoreo / Observabilidad

Estado:

```text
Completada en alcance básico
```

Servicios desplegados:

| Servicio | Host | IP | Puerto | Estado |
|---|---|---:|---:|---|
| Node Exporter | admin-01 | 192.168.0.201 | 9100 | Funcionando |
| Node Exporter | monitor-01 | 192.168.0.202 | 9100 | Funcionando |
| Prometheus | monitor-01 | 192.168.0.202 | 9090 | Funcionando |
| Grafana | monitor-01 | 192.168.0.202 | 3000 | Funcionando |

Validaciones completadas:

```text
Node Exporter responde en ambos hosts
Prometheus responde y consulta ambos targets
Grafana está conectado a Prometheus mediante http://localhost:9090
Dashboard inicial de Node Exporter validado
Puertos 9090, 3000 y 9100 habilitados según el host
```

Documentación relacionada:

```text
docs/monitoring.md
docs/monitoring-operations.md
```

Profundizaciones reservadas para una fase futura:

```text
Alertas y Alertmanager
Dashboards más específicos
Métricas de Proxmox
Logs centralizados
Hardening de Grafana
Backups o exportación de dashboards
```

---

## Validaciones generales completadas

### Template y clonación

```text
Template oficial VMID 200 validado
Cloud-Init aplicado
SSH por llave validado
QEMU Guest Agent habilitado
Clonado desde template probado
Machine ID único en los clones
```

### Ansible

```text
Inventario funcional
Conexión Ansible validada
Roles base y de monitoreo creados
site.yml aplicado correctamente
Documentación Ansible creada
```

### Monitoreo

```text
monitor-01 creada y administrada por Ansible
Node Exporter funcional
Prometheus funcional
Grafana funcional
Datasource y dashboard inicial validados
```

---

## Próximo paso recomendado

Cuando se decida continuar el roadmap, iniciar:

```text
Fase 5 — Red híbrida con Azure
```

Antes de implementar cambios, definir el alcance mínimo de conectividad, direccionamiento, seguridad y recursos de Azure.

---

## Fuera del alcance inmediato

No ampliar por ahora las fases ya cerradas con mejoras opcionales. También queda fuera del roadmap inmediato crear tags únicos para ejecutar tareas individuales; esa fue una duda puntual y no una línea de trabajo del proyecto.
