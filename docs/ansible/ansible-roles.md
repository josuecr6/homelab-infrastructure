# Ansible Roles

Este documento describe la organización actual de roles Ansible en el proyecto **homelab-infrastructure**.

El objetivo de usar roles es separar la configuración por responsabilidad, mantener los playbooks simples y facilitar la reutilización en otros hosts del laboratorio.

---

## Estructura general

```text
ansible/
├── ansible.cfg
├── inventory/
│   ├── hosts.ini
│   └── group_vars/
│       └── all/
│           └── main.yml
├── playbooks/
│   ├── check-host.yml
│   ├── base-rocky.yml
│   ├── users.yml
│   ├── ssh-hardening.yml
│   ├── firewall.yml
│   ├── system-update.yml
│   ├── node_exporter.yml
│   ├── prometheus.yml
│   ├── grafana.yml
│   └── site.yml
└── roles/
    ├── base/
    ├── users/
    ├── ssh_hardening/
    ├── firewall/
    ├── system_update/
    ├── node_exporter/
    ├── prometheus/
    └── grafana/
```

---

## Configuración de Ansible

Archivo principal:

```text
ansible/ansible.cfg
```

Configuración base esperada:

```ini
[defaults]
inventory = inventory/hosts.ini
roles_path = roles
host_key_checking = False
retry_files_enabled = False
interpreter_python = auto_silent
```

La opción:

```ini
roles_path = roles
```

indica que los roles se buscan dentro de `ansible/roles/`.

---

## Inventario

Archivo:

```text
ansible/inventory/hosts.ini
```

Grupos principales:

```text
admin
monitoring
```

Hosts actuales:

| Grupo | Host | IP | Rol |
|---|---|---:|---|
| admin | admin-01 | 192.168.0.201 | Nodo administrador Ansible |
| monitoring | monitor-01 | 192.168.0.202 | Nodo de monitoreo |

Las variables compartidas para sistemas Rocky Linux y los roles se mantienen en:

```text
ansible/inventory/group_vars/all/main.yml
```

---

## Playbook principal

Archivo:

```text
ansible/playbooks/site.yml
```

Importaciones actuales:

```yaml
---
- import_playbook: base-rocky.yml
- import_playbook: users.yml
- import_playbook: ssh-hardening.yml
- import_playbook: firewall.yml
- import_playbook: system-update.yml
- import_playbook: node_exporter.yml
- import_playbook: prometheus.yml
- import_playbook: grafana.yml
```

Ejecución general desde `admin-01`:

```bash
cd ~/homelab/homelab-infrastructure/ansible
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

---

## Roles actuales

### `base`

Responsabilidades:

- validar Rocky Linux;
- mostrar información básica del host;
- instalar paquetes base;
- habilitar servicios base como `chronyd` y QEMU Guest Agent.

Tag principal:

```text
base
```

### `users`

Responsabilidades:

- crear o asegurar el usuario administrativo `jocufe`;
- configurar el grupo `wheel`;
- instalar la llave pública SSH;
- administrar el archivo de sudoers.

Tag principal:

```text
users
```

### `ssh_hardening`

Responsabilidades:

- crear el drop-in `/etc/ssh/sshd_config.d/99-homelab.conf`;
- impedir acceso SSH directo de root;
- habilitar autenticación por llave;
- deshabilitar autenticación por contraseña;
- validar y recargar `sshd` mediante un handler.

Tag principal:

```text
ssh
```

### `firewall`

Responsabilidades:

- instalar y habilitar `firewalld`;
- permitir servicios y puertos definidos por variables;
- aplicar reglas permanentes e inmediatas.

Tag principal:

```text
firewall
```

### `system_update`

Responsabilidades:

- actualizar paquetes mediante DNF;
- registrar el resultado de la actualización;
- informar cuando se aplican cambios.

Tag principal:

```text
system_update
```

### `node_exporter`

Responsabilidades:

- crear el usuario y grupo de servicio;
- instalar el binario de Node Exporter;
- crear y habilitar el servicio systemd;
- permitir el puerto `9100/tcp`;
- exponer métricas básicas del sistema.

Hosts actuales:

```text
admin-01
monitor-01
```

Tag principal:

```text
node_exporter
```

### `prometheus`

Responsabilidades:

- instalar Prometheus y `promtool`;
- administrar la configuración y targets;
- crear y habilitar el servicio systemd;
- permitir el puerto `9090/tcp`.

Host actual:

```text
monitor-01
```

Tag principal:

```text
prometheus
```

### `grafana`

Responsabilidades:

- instalar Grafana;
- habilitar e iniciar `grafana-server`;
- permitir el puerto `3000/tcp`;
- dejar disponible la interfaz para configurar Prometheus y dashboards.

Host actual:

```text
monitor-01
```

Tag principal:

```text
grafana
```

---

## Relación entre roles y hosts

| Rol | admin-01 | monitor-01 |
|---|:---:|:---:|
| base | Sí | Sí |
| users | Sí | Sí |
| ssh_hardening | Sí | Sí |
| firewall | Sí | Sí |
| system_update | Sí | Sí |
| node_exporter | Sí | Sí |
| prometheus | No | Sí |
| grafana | No | Sí |

La aplicación exacta depende de los grupos definidos en cada playbook.

---

## Comandos frecuentes

Validar sintaxis:

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

Listar tareas:

```bash
ansible-playbook playbooks/site.yml --list-tasks
```

Listar tags:

```bash
ansible-playbook playbooks/site.yml --list-tags
```

Ejecutar toda la configuración:

```bash
ansible-playbook playbooks/site.yml -K
```

Limitar la ejecución a un grupo:

```bash
ansible-playbook playbooks/site.yml -K --limit monitoring
```

Ejecutar un rol mediante su tag principal:

```bash
ansible-playbook playbooks/site.yml -K --tags prometheus
```

Los tags se usan para ejecutar bloques funcionales existentes. No forma parte del alcance actual crear tags únicos para ejecutar tareas individuales.

---

## Estado de la estructura

```text
Roles base: completados
Roles de monitoreo: completados en alcance básico
Integración en site.yml: completada
Documentación: actualizada al cierre de la Fase 4
```
