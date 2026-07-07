`admin-01` es el nodo administrador del proyecto **homelab-infrastructure**.

Desde este servidor se ejecutan las tareas de automatización local con Ansible y se administra la configuración base de los hosts del laboratorio.

---

## Propósito

`admin-01` centraliza la administración del homelab.

Desde este nodo se gestionan:

- inventarios de Ansible;
- playbooks;
- roles;
- llaves SSH de administración;
- documentación operativa;
- futuras automatizaciones del laboratorio.

Este servidor pertenece a la fase actual del proyecto:

```text
Fase 3 — Automatización local con Ansible
```

---

## Datos básicos

```text
Hostname: admin-01
Sistema operativo: Rocky Linux
Usuario administrativo: jocufe
Función: nodo administrador Ansible
```

---

## Ubicación del repositorio

El repositorio del proyecto se encuentra en:

```text
~/homelab/homelab-infrastructure
```

Para trabajar con Ansible:

```bash
cd ~/homelab/homelab-infrastructure/ansible
```

Estructura principal relacionada:

```text
homelab-infrastructure/
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
└── docs/
    └── ansible/
```

---

## Usuario administrativo

El usuario principal usado para la administración es:

```text
jocufe
```

Este usuario se usa para conectarse por SSH y ejecutar tareas de Ansible.

Cuando un playbook necesita privilegios elevados se usa:

```yaml
become: true
```

En ejecución manual normalmente se usa:

```bash
ansible-playbook playbooks/site.yml -K
```

---

## Llave SSH de Ansible

La llave SSH usada por Ansible está referenciada en el inventario:

```text
~/.ssh/ansible_admin01
```

Esta llave permite que Ansible se conecte al host sin pedir contraseña SSH.

---

## Inventario

El inventario principal está en:

```text
ansible/inventory/hosts.ini
```

El grupo usado actualmente es:

```text
admin
```

Ejemplo:

```ini
[admin]
admin-01 ansible_host=192.168.0.201 ansible_user=jocufe ansible_ssh_private_key_file=~/.ssh/ansible_admin01
```

---

## Playbook principal

El punto de entrada general es:

```text
ansible/playbooks/site.yml
```

Ejecución desde el directorio `ansible/`:

```bash
ansible-playbook playbooks/site.yml -K
```

---

## Roles aplicados

Los roles actuales aplicables sobre `admin-01` son:

```text
base
users
ssh_hardening
firewall
system_update
```

La documentación detallada de los roles está en:

```text
docs/ansible/ansible-roles.md
```

---

## Comandos frecuentes

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

`-K` = **K MAYÚSCULA**, contraseña de `sudo` / `become`.

---

## Consideraciones de seguridad

Antes de aplicar cambios relacionados con SSH:

- mantener una sesión SSH abierta;
- confirmar que la llave SSH funciona;
- no cerrar la sesión actual hasta validar el nuevo acceso;
- validar la configuración de `sshd` antes de recargar el servicio.

El hardening de SSH está documentado en:

```text
docs/ansible/security-hardening.md
```

---

## Estado actual

`admin-01` ya funciona como nodo administrador inicial del laboratorio.

Desde este servidor se está cerrando la base de Ansible antes de continuar con las siguientes fases del proyecto.

Todavía no corresponde abrir:

- monitoreo;
- red híbrida con Azure;
- backups híbridos.

Primero se debe cerrar la documentación y validación de Ansible.
