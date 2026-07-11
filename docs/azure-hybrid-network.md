# Fase 5 — Red híbrida con Azure

## Objetivo

Conectar el homelab local con Microsoft Azure mediante una VPN Site-to-Site.

La conexión permitirá comunicación privada entre la red local del laboratorio y una red virtual en Azure.

## Alcance inicial

Incluye:

- Diseño de direccionamiento
- Resource Group en Azure
- Virtual Network
- GatewaySubnet
- VPN Gateway
- Local Network Gateway
- Conexión Site-to-Site
- Validación de conectividad básica

No incluye inicialmente:

- Alta disponibilidad
- BGP
- ExpressRoute
- Firewall centralizado
- DNS privado avanzado
- Monitoreo avanzado de la VPN

## Red local

| Elemento | Valor |
|---|---|
| LAN local | 192.168.0.0/24 |
| Proxmox | 192.168.0.99 |
| admin-01 | 192.168.0.201 |
| monitor-01 | 192.168.0.202 |

## Red Azure propuesta

| Elemento | Valor |
|---|---|
| VNet | 10.50.0.0/16 |
| Subnet workloads | 10.50.1.0/24 |
| GatewaySubnet | 10.50.255.0/27 |

## Arquitectura lógica

```text
Homelab local
192.168.0.0/24
        |
        | VPN Site-to-Site IPsec/IKE
        |
Azure VNet
10.50.0.0/16
```

## Componentes Azure

| Componente | Propósito |
|---|---|
| Resource Group | Agrupar recursos de la fase |
| Virtual Network | Red privada en Azure |
| GatewaySubnet | Subnet reservada para Azure VPN Gateway |
| Public IP | IP pública del gateway de Azure |
| Virtual Network Gateway | Gateway VPN del lado Azure |
| Local Network Gateway | Representación de la red local en Azure |
| VPN Connection | Túnel entre Azure y homelab |

## Nombres propuestos

| Recurso | Nombre |
|---|---|
| Resource Group | rg-homelab-network |
| VNet | vnet-homelab-azure |
| Workload subnet | snet-workloads |
| Gateway subnet | GatewaySubnet |
| Public IP | pip-vgw-homelab |
| Virtual Network Gateway | vgw-homelab |
| Local Network Gateway | lng-homelab-local |
| VPN Connection | conn-homelab-s2s |

## Estado

Estado actual:

- Fase 5 documentada antes de iniciar implementación
- Diseño base definido
- Implementación pendiente

## Pendientes

- Confirmar IP pública o DDNS del router local
- Confirmar si el router local soporta VPN Site-to-Site IPsec/IKE
- Crear recursos base en Azure
- Configurar túnel VPN
- Validar conectividad
