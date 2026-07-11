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
| admin-01 | 192.168.0.201 | Nodo administrado por Ansible |
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

```
http://192.168.0.202:3000

Node Exporter en admin-01:

http://192.168.0.201:9100/metrics

Node Exporter en monitor-01:

http://192.168.0.202:9100/metrics
```
