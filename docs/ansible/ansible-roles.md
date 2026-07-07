# Ansible Roles

Este documento describe cómo está organizada la estructura de roles Ansible en el proyecto **homelab-infrastructure**.

El objetivo de usar roles es separar la lógica de configuración por responsabilidad, mantener los playbooks más limpios y facilitar la reutilización de tareas en otros hosts o grupos del homelab.

---

## Estructura general

La estructura principal de Ansible se encuentra en:

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
│   └── site.yml
└── roles/
    ├── base/
    │   └── tasks/
    │       └── main.yml
    ├── users/
    │   └── tasks/
    │       └── main.yml
    ├── ssh_hardening/
    │   ├── tasks/
    │   │   └── main.yml
    │   └── handlers/
    │       └── main.yml
    ├── firewall/
    │   └── tasks/
    │       └── main.yml
    └── system_update/
        └── tasks/
            └── main.yml
```

---

## Configuración de Ansible

El archivo principal de configuración está en:

```text
ansible/ansible.cfg
```

Contenido esperado:

```ini
[defaults]
inventory = inventory/hosts.ini
roles_path = roles
host_key_checking = False
retry_files_enabled = False
interpreter_python = auto_silent
```

La línea más importante para roles es:

```ini
roles_path = roles
```

Esto indica que Ansible debe buscar roles dentro de:

```text
ansible/roles/
```

Sin esta línea, al ejecutar playbooks desde `ansible/playbooks/`, Ansible puede intentar buscar roles en una ruta incorrecta como:

```text
ansible/playbooks/roles/
```

---

## Inventario

El inventario actual está en:

```text
ansible/inventory/hosts.ini
```

Ejemplo actual:

```ini
[admin]
admin-01 ansible_host=192.168.0.201 ansible_user=jocufe ansible_ssh_private_key_file=~/.ssh/ansible_admin01
```

El grupo principal usado hasta ahora es:

```text
admin
```

El host actual administrado es:

```text
admin-01
```

---

## Variables globales

Las variables globales están en:

```text
ansible/inventory/group_vars/all/main.yml
```

Este archivo contiene variables compartidas por los roles.

Ejemplos:

```yaml
admin_user: jocufe
admin_user_groups:
  - wheel
admin_user_shell: /bin/bash
admin_ssh_public_key: "ssh-ed25519 ... ansible admin-01 local"

ssh_permit_root_login: "no"
ssh_pubkey_authentication: "yes"
ssh_password_authentication: "no"

firewall_allowed_services:
  - ssh
```

Estas variables permiten que los roles no tengan valores quemados directamente en las tareas.

---

## Playbooks principales

Los playbooks se encuentran en:

```text
ansible/playbooks/
```

Cada playbook principal llama a un rol.

### `base-rocky.yml`

Ejecuta el rol `base`.

```yaml
---
- name: Apply base Rocky Linux configuration
  hosts: admin
  become: true
  gather_facts: true

  roles:
    - base
```

Este playbook mantiene `gather_facts: true` porque el rol `base` usa facts como:

```text
ansible_distribution
ansible_distribution_version
ansible_hostname
```

### `users.yml`

Ejecuta el rol `users`.

```yaml
---
- name: Apply base user configuration
  hosts: admin
  become: true
  gather_facts: false

  roles:
    - users
```

### `ssh-hardening.yml`

Ejecuta el rol `ssh_hardening`.

```yaml
---
- name: Apply basic SSH hardening
  hosts: admin
  become: true
  gather_facts: false

  roles:
    - ssh_hardening
```

### `firewall.yml`

Ejecuta el rol `firewall`.

```yaml
---
- name: Configure basic firewall
  hosts: admin
  become: true
  gather_facts: false

  roles:
    - firewall
```

### `system-update.yml`

Ejecuta el rol `system_update`.

```yaml
---
- name: Update Rocky Linux systems
  hosts: admin
  become: true
  gather_facts: false

  roles:
    - system_update
```

---

## Playbook principal `site.yml`

El playbook `site.yml` es el punto de entrada general.

Archivo:

```text
ansible/playbooks/site.yml
```

Contenido actual:

```yaml
---
- import_playbook: base-rocky.yml
- import_playbook: users.yml
- import_playbook: ssh-hardening.yml
- import_playbook: firewall.yml
- import_playbook: system-update.yml
```

Este archivo permite ejecutar toda la configuración base del host usando un solo comando.

---

## Roles actuales

### Rol `base`

Ruta:

```text
ansible/roles/base/
```

Responsabilidad:

* Validar que el sistema sea Rocky Linux.
* Mostrar información básica del host.
* Instalar paquetes base.
* Habilitar e iniciar `chronyd`.
* Habilitar e iniciar `qemu-guest-agent`.

Tareas principales:

```text
roles/base/tasks/main.yml
```

Tags usados:

```text
base
validation
info
packages
services
chrony
qemu
```

---

### Rol `users`

Ruta:

```text
ansible/roles/users/
```

Responsabilidad:

* Crear o asegurar el usuario administrador.
* Configurar directorio `.ssh`.
* Instalar llave pública SSH.
* Configurar sudoers con validación usando `visudo`.

Tareas principales:

```text
roles/users/tasks/main.yml
```

Tags usados:

```text
users
accounts
ssh_keys
sudoers
```

---

### Rol `ssh_hardening`

Ruta:

```text
ansible/roles/ssh_hardening/
```

Responsabilidad:

* Configurar un drop-in SSH en:

```text
/etc/ssh/sshd_config.d/99-homelab.conf
```

* Aplicar valores como:

```text
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
```

* Validar la configuración de SSH antes de recargar el servicio.

Archivos principales:

```text
roles/ssh_hardening/tasks/main.yml
roles/ssh_hardening/handlers/main.yml
```

Flujo del handler:

```text
copy cambia archivo
  -> notify Reload sshd
    -> validar sshd con /usr/sbin/sshd -t
      -> si pasa, recargar sshd
```

Tags usados:

```text
ssh
ssh_hardening
```

Nota importante:

Antes de aplicar cambios de SSH, mantener una sesión SSH abierta por seguridad.

---

### Rol `firewall`

Ruta:

```text
ansible/roles/firewall/
```

Responsabilidad:

* Instalar `firewalld`.
* Habilitar e iniciar `firewalld`.
* Permitir servicios definidos en:

```yaml
firewall_allowed_services:
  - ssh
```

Tareas principales:

```text
roles/firewall/tasks/main.yml
```

Módulo usado:

```text
ansible.posix.firewalld
```

Opciones usadas:

```yaml
permanent: true
immediate: true
state: enabled
```

Tags usados:

```text
firewall
packages
services
firewall_rules
```

---

### Rol `system_update`

Ruta:

```text
ansible/roles/system_update/
```

Responsabilidad:

* Actualizar paquetes del sistema.
* Registrar el resultado de la actualización.
* Mostrar mensaje solo si hubo cambios.

Tareas principales:

```text
roles/system_update/tasks/main.yml
```

Conceptos usados:

```yaml
register: system_update_result
when: system_update_result.changed
```

Tags usados:

```text
system_update
packages
info
```

---

## Comandos frecuentes

Entrar al directorio Ansible:

```bash
cd ~/homelab/homelab-infrastructure/ansible
```

Validar qué configuración está usando Ansible:

```bash
ansible --version | grep "config file"
```

Validar sintaxis de todo el sitio:

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

Listar tags:

```bash
ansible-playbook playbooks/site.yml --list-tags
```

Listar tareas:

```bash
ansible-playbook playbooks/site.yml --list-tasks
```

Listar tareas de un tag específico:

```bash
ansible-playbook playbooks/site.yml --tags firewall --list-tasks
```

Ejecutar todo el sitio:

```bash
ansible-playbook playbooks/site.yml -K
```

Ejecutar solo un tag:

```bash
ansible-playbook playbooks/site.yml -K --tags firewall
```

Ejecutar un playbook específico:

```bash
ansible-playbook playbooks/firewall.yml -K
```

Ejecutar un tag desde un playbook específico:

```bash
ansible-playbook playbooks/firewall.yml -K --tags firewall
```

---

## Ejecución por tags

Los tags permiten ejecutar solo una parte del playbook.

Ejemplo:

```bash
ansible-playbook playbooks/site.yml -K --tags firewall
```

Esto ejecuta todas las tareas que tengan el tag:

```text
firewall
```

Si varias tareas tienen el mismo tag, todas se ejecutan.

Ejemplo en el rol `firewall`:

```text
firewall : Install firewalld
firewall : Enable and start firewalld
firewall : Allow configured firewall services
```

Todas pueden ejecutarse con:

```bash
ansible-playbook playbooks/site.yml -K --tags firewall
```

---
