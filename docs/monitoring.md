# Monitoreo / Observabilidad

## Objetivo

Implementar una capa básica de monitoreo para observar el estado de las VMs principales del homelab mediante Prometheus, Grafana y Node Exporter.

La Fase 4 quedó completada en alcance básico y deja una base funcional para futuras mejoras de observabilidad.

## Alcance completado

Esta fase incluye:

- VM dedicada `monitor-01`.
- Prometheus en `monitor-01`.
- Grafana en `monitor-01`.
- Node Exporter en `admin-01` y `monitor-01`.
- Monitoreo básico de sistema.
- Datasource de Grafana conectado a Prometheus.
- Dashboard inicial de Node Exporter validado.

Queda fuera del alcance actual:

- Alertas y Alertmanager.
- Dashboards especializados.
- Monitoreo profundo de Proxmox.
- Logs centralizados.
- Integración con Azure.
- Backups de métricas y dashboards.
- Hardening avanzado de Grafana.

## Arquitectura actual

```text
Proxmox host: rdaneel
   |
   |-- VM 201 admin-01 (192.168.0.201)
   |      |-- Node Exporter :9100
   |
   |-- VM 202 monitor-01 (192.168.0.202)
          |-- Prometheus    :9090
          |-- Grafana       :3000
          |-- Node Exporter :9100
```

## Estado actual

```text
Fase 4 — Monitoreo / Observabilidad
Estado: completada en alcance básico
```

### Servicios desplegados

| Servicio | Host | IP | Puerto | Estado |
|---|---|---:|---:|---|
| Node Exporter | admin-01 | 192.168.0.201 | 9100 | Funcionando |
| Node Exporter | monitor-01 | 192.168.0.202 | 9100 | Funcionando |
| Prometheus | monitor-01 | 192.168.0.202 | 9090 | Funcionando |
| Grafana | monitor-01 | 192.168.0.202 | 3000 | Funcionando |

## Accesos

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

## Integración Grafana y Prometheus

Grafana usa el siguiente datasource desde `monitor-01`:

```text
http://localhost:9090
```

El datasource fue validado y se confirmó la visualización de métricas mediante un dashboard inicial de Node Exporter.

## Automatización Ansible

Roles relacionados:

```text
ansible/roles/node_exporter/
ansible/roles/prometheus/
ansible/roles/grafana/
```

Playbooks relacionados:

```text
ansible/playbooks/node_exporter.yml
ansible/playbooks/prometheus.yml
ansible/playbooks/grafana.yml
```

Los tres playbooks están integrados en:

```text
ansible/playbooks/site.yml
```

## Operación

Las verificaciones y comandos operativos básicos están documentados en:

```text
docs/monitoring-operations.md
```

## Mejoras futuras

Las siguientes mejoras quedan reservadas para una profundización posterior, sin reabrir el alcance básico de la Fase 4:

```text
Alertmanager y reglas de alerta
Dashboards específicos por servicio
Métricas del host Proxmox
Logs centralizados
Hardening de Grafana
Exportación y respaldo de dashboards
```
