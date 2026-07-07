# Security Hardening

Este documento describe las medidas básicas de seguridad aplicadas en la fase actual del proyecto **homelab-infrastructure**.

El alcance actual es mantener una base segura y simple para los servidores Linux administrados con Ansible.

---

## Fase del proyecto

Este documento pertenece a:

```text
Fase 3 — Automatización local con Ansible
```

El objetivo no es implementar hardening avanzado todavía, sino dejar una base inicial repetible.

---

## Usuario administrativo

El usuario administrativo principal del laboratorio es:

```text
jocufe
```

Este usuario se usa para:

- conexión SSH;
- ejecución de tareas Ansible;
- administración con privilegios mediante `sudo`.

La configuración del usuario se gestiona desde el rol:

```text
users
```

Ruta del rol:

```text
ansible/roles/users/
```

---

## Sudoers

El rol `users` configura permisos administrativos para el usuario principal.

La configuración de sudoers debe validarse siempre con:

```text
visudo
```

En Ansible, esto debe hacerse usando validación antes de escribir cambios definitivos en sudoers.

Objetivo:

```text
evitar dejar el sistema sin acceso administrativo por una mala configuración de sudo
```

---

## Acceso SSH

El acceso SSH se endurece desde el rol:

```text
ssh_hardening
```

Ruta del rol:

```text
ansible/roles/ssh_hardening/
```

La configuración se aplica mediante un archivo drop-in:

```text
/etc/ssh/sshd_config.d/99-homelab.conf
```

Valores base esperados:

```text
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
```

Esto significa:

- no permitir login directo como `root`;
- permitir autenticación por llave pública;
- deshabilitar autenticación por contraseña SSH.

---

## Precauciones antes de aplicar cambios SSH

Antes de aplicar cambios de SSH:

- mantener una sesión SSH abierta;
- confirmar que la llave SSH funciona;
- no cerrar la sesión actual hasta validar el nuevo acceso;
- validar la configuración de `sshd`;
- recargar el servicio solo si la validación fue exitosa.

El flujo esperado del rol es:

```text
copiar configuración SSH
validar configuración con sshd -t
recargar sshd solo si la validación pasa
```

---

## Llave SSH de Ansible

La llave usada por Ansible está referenciada en el inventario:

```text
~/.ssh/ansible_admin01
```

El inventario actual está en:

```text
ansible/inventory/hosts.ini
```

Ejemplo:

```ini
[admin]
admin-01 ansible_host=192.168.0.201 ansible_user=jocufe ansible_ssh_private_key_file=~/.ssh/ansible_admin01
```

---

## Firewall

La configuración básica de firewall se gestiona desde el rol:

```text
firewall
```

Ruta del rol:

```text
ansible/roles/firewall/
```

El servicio usado es:

```text
firewalld
```

Servicios permitidos actualmente:

```yaml
firewall_allowed_services:
  - ssh
```

El objetivo inicial es mantener permitido el acceso SSH y evitar abrir servicios innecesarios.

---

## Servicios base relacionados

Los servicios principales relacionados con esta fase son:

```text
sshd
firewalld
chronyd
qemu-guest-agent
```

Estos servicios son administrados por roles Ansible según corresponda.

---

## Comandos útiles

Validar sintaxis del sitio completo:

```bash
cd ~/homelab/homelab-infrastructure/ansible
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

Ejecutar solo configuración SSH:

```bash
ansible-playbook playbooks/ssh-hardening.yml -K
```

Ejecutar solo configuración de firewall:

```bash
ansible-playbook playbooks/firewall.yml -K
```

---

## Fuera del alcance por ahora

Por ahora no se incluyen:

- IDS/IPS;
- SIEM;
- VPN;
- certificados TLS;
- escaneo de vulnerabilidades;
- políticas avanzadas de firewall;
- hardening CIS completo;
- monitoreo de seguridad;
- integración con Azure.

Estos temas pueden evaluarse en fases posteriores del proyecto.

---

## Estado actual

El hardening actual es básico y suficiente para cerrar la base inicial de Ansible.

Antes de avanzar a monitoreo, Azure o backups, se debe terminar de validar que los roles actuales funcionen correctamente sobre `admin-01`.
