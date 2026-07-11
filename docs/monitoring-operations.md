# Operación básica de monitoreo

Este documento describe las validaciones básicas para operar el stack de monitoreo del homelab.

## Stack actual

La Fase 4 — Monitoreo / Observabilidad usa:

- Prometheus
- Grafana
- Node Exporter

## Hosts involucrados

| Host | IP | Rol |
|---|---:|---|
| admin-01 | 192.168.0.201 | Nodo administrador y host monitoreado |
| monitor-01 | 192.168.0.202 | Nodo de monitoreo |

## Servicios

| Servicio | Host | Puerto |
|---|---|---:|
| Node Exporter | admin-01 | 9100 |
| Node Exporter | monitor-01 | 9100 |
| Prometheus | monitor-01 | 9090 |
| Grafana | monitor-01 | 3000 |

## URLs principales

Prometheus:

```text
http://192.168.0.202:9090
```

Grafana:

```text
http://192.168.0.202:3000
```

Node Exporter en `admin-01`:

```text
http://192.168.0.201:9100/metrics
```

Node Exporter en `monitor-01`:

```text
http://192.168.0.202:9100/metrics
```

## Verificación de servicios

En `admin-01`:

```bash
sudo systemctl status node_exporter
curl http://localhost:9100/metrics
```

En `monitor-01`:

```bash
sudo systemctl status node_exporter
sudo systemctl status prometheus
sudo systemctl status grafana-server

curl http://localhost:9100/metrics
curl http://localhost:9090/-/ready
curl -I http://localhost:3000
```

## Verificación de puertos

En cada host se pueden revisar los puertos en escucha con:

```bash
sudo ss -lntp
```

Puertos esperados en `monitor-01`:

```text
3000/tcp  Grafana
9090/tcp  Prometheus
9100/tcp  Node Exporter
```

Puerto esperado en `admin-01`:

```text
9100/tcp  Node Exporter
```

## Prometheus

Desde la interfaz de Prometheus, revisar:

```text
Status > Targets
```

Los targets iniciales esperados son:

```text
admin-01:9100
monitor-01:9100
```

Ambos deben aparecer en estado `UP`.

## Grafana

Datasource configurado:

```text
Nombre: Prometheus
URL: http://localhost:9090
```

La conexión al datasource y el dashboard inicial de Node Exporter fueron validados durante el cierre de la Fase 4.

## Ejecución con Ansible

Desde el directorio `ansible/` en `admin-01`:

```bash
ansible-playbook playbooks/site.yml -K
```

`-K` usa **K MAYÚSCULA** y solicita la contraseña de `sudo` / `become`.

Para limitar la ejecución al stack de monitoreo pueden utilizarse los tags ya definidos por los roles, sin convertir tareas individuales en una nueva línea de trabajo.

## Alcance operativo

Este documento cubre únicamente la operación básica. Alertas, logs, métricas de Proxmox, hardening de Grafana y backups de dashboards quedan pendientes para una profundización futura.
