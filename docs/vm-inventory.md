# VM Inventory

Inventario actual de máquinas virtuales y templates del laboratorio Proxmox.

---

## Templates

| VMID | Nombre | Sistema | Estado | Uso |
|---|---|---|---|---|
| 200 | rocky9-cloud-template | Rocky Linux 9 | Template | Plantilla base oficial Cloud-Init |

---

## Virtual Machines

| VMID | Nombre | IP | Sistema | Estado | Rol | Servicios | Puertos |
|---|---|---|---|---|---|---|---|
| 201 | admin-01 | 192.168.0.201 | Rocky Linux 9 | Running | Nodo administrador Ansible | Ansible, Node Exporter | 9100/tcp |
| 202 | monitor-01 | 192.168.0.202 | Rocky Linux 9 | Running | Monitoreo / Observabilidad | Prometheus, Grafana, Node Exporter | 9090/tcp, 3000/tcp, 9100/tcp |

---

## Template oficial

```text
VMID: 200
Nombre: rocky9-cloud-template
Uso: base para clonar nuevas VMs Rocky Linux 9
Cloud-Init: habilitado
QEMU Guest Agent: habilitado
Bridge: vmbr0
Storage: local-lvm
```

El template debe conservar `/etc/machine-id` vacío antes de usarse como base para nuevos clones.

---

## VM administrativa

```text
VMID: 201
Nombre: admin-01
IP: 192.168.0.201
Rol: nodo administrador Ansible
Usuario administrativo: jocufe
```

`admin-01` fue creada desde el template oficial y se utiliza para:

- ejecutar Ansible;
- administrar el inventario;
- aplicar playbooks;
- mantener el repositorio local;
- operar la infraestructura del homelab.

Servicios actuales:

```text
Ansible
Node Exporter :9100
```

---

## VM de monitoreo

```text
VMID: 202
Nombre: monitor-01
IP: 192.168.0.202
Rol: monitoreo y observabilidad
Usuario administrativo: jocufe
```

`monitor-01` fue creada desde el template oficial VMID 200 y aloja el stack básico de monitoreo.

Servicios actuales:

```text
Prometheus    :9090
Grafana       :3000
Node Exporter :9100
```

La VM está incluida en el inventario Ansible y su configuración se administra mediante los roles de monitoreo.

---

## Script de clonación

Script disponible:

```text
scripts/clone-rocky9-vm.sh
```

Ejemplo de clonación de `admin-01`:

```bash
./scripts/clone-rocky9-vm.sh 201 admin-01
```

El script debe ejecutarse desde el host Proxmox, donde está disponible el comando `qm`.

---

## Validaciones generales de los clones

Para cada VM se debe validar:

- arranque correcto;
- red y dirección IP;
- acceso SSH por llave;
- hostname correcto;
- QEMU Guest Agent;
- `machine-id` único;
- inclusión en el inventario Ansible cuando corresponda.

---

## Machine ID

Cada clon debe generar un identificador único al iniciar. El template oficial debe mantenerse preparado para evitar que las VMs hereden el mismo `/etc/machine-id`.
