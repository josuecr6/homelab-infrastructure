# Monitoreo / Observabilidad

## Objetivo

Implementar una capa inicial de monitoreo para el homelab usando Prometheus, Grafana y Node Exporter.

El objetivo de esta fase es observar el estado básico de las VMs y dejar una base documentada para crecer después.

## Alcance inicial

Esta fase incluye:

- Crear una VM dedicada para monitoreo.
- Instalar Prometheus.
- Instalar Grafana.
- Instalar Node Exporter en los primeros hosts.
- Monitorear métricas básicas de sistema.

Esta fase no incluye todavía:

- Alertas avanzadas.
- Monitoreo profundo de Proxmox.
- Logs centralizados.
- Integración con Azure.
- Backups de métricas.

## Arquitectura inicial

```text
Proxmox host
   |
   |-- VM 201 admin-01
   |      |-- node_exporter
   |
   |-- VM 202 monitor-01
          |-- Prometheus
          |-- Grafana
          |-- node_exporter
