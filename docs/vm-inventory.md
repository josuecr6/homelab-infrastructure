# VM Inventory

Inventario inicial de máquinas virtuales del laboratorio Proxmox.

---

## Templates

| VMID | Nombre | Sistema | Estado | Uso |
|---|---|---|---|---|
| 200 | rocky9-cloud-template | Rocky Linux 9 | Template | Plantilla base oficial Cloud-Init |

---

## Virtual Machines

| VMID | Nombre | IP | Sistema | Estado | Rol |
|---|---|---|---|---|---|
| 201 | admin-01 | 192.168.0.201 | Rocky Linux 9 | Running | Nodo administrador Ansible |

---

## Template oficial

El template oficial Rocky Linux 9 del proyecto es:

```text
VMID: 200
Nombre: rocky9-cloud-template
Uso: base para clonar nuevas VMs Rocky Linux 9
```

---

## VM administrativa

La VM administrativa actual es:

```text
VMID: 201
Nombre: admin-01
IP: 192.168.0.201
Rol: nodo administrador Ansible
```

La VM `admin-01` fue creada desde el template oficial `rocky9-cloud-template`.

Script usado:

```text
scripts/clone-rocky9-vm.sh
```

Comando utilizado:

```bash
./scripts/clone-rocky9-vm.sh 201 admin-01
```

---

## Validaciones realizadas sobre admin-01

Se validó:

- arranque correcto;
- DHCP correcto;
- SSH correcto;
- hostname correcto;
- QEMU Guest Agent correcto;
- ejecución de Ansible desde `admin-01`.

---

## Corrección de Machine ID

Durante la validación de `admin-01`, se detectó que el `machine-id` había sido heredado desde el template original.

Se corrigió generando un nuevo identificador único dentro de la VM:

```bash
sudo cp /etc/machine-id /etc/machine-id.bak
sudo truncate -s 0 /etc/machine-id
sudo systemd-machine-id-setup
```

Validación:

```bash
hostnamectl
```

Resultado:

```text
La VM admin-01 ahora tiene un Machine ID único.
```

---

## Notas

El template oficial `rocky9-cloud-template` debe mantenerse con `/etc/machine-id` vacío antes de convertirlo en template o antes de usarlo como base para nuevos clones.

Cada clon debe generar su propio `machine-id` al iniciar.
