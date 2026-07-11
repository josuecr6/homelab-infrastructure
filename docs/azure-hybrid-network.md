# Fase 5 — Red híbrida con Azure

## Objetivo

Conectar el homelab local con Microsoft Azure usando Tailscale como red privada superpuesta.

La conexión permitirá comunicación privada entre la red local del laboratorio y una red virtual en Azure, sin depender de una IP pública entrante en el router local.

## Decisión de arquitectura

El homelab local está detrás de CGNAT.

Por esta razón, se descarta en el alcance inicial una VPN Site-to-Site clásica basada en IPsec/IKE con Azure VPN Gateway, ya que ese modelo normalmente requiere una IP pública o un endpoint alcanzable del lado local.

La alternativa seleccionada para el alcance básico de la Fase 5 es Tailscale.

## Alcance inicial

Incluye:

- Diseño de direccionamiento
- Resource Group en Azure
- Virtual Network en Azure
- Subnet de workloads en Azure
- VM Linux en Azure como nodo Tailscale
- Tailscale instalado en el homelab
- Tailscale instalado en Azure
- Subnet router local para anunciar la LAN del homelab
- Subnet router en Azure para anunciar la red de Azure
- Validación de conectividad entre redes privadas

No incluye inicialmente:

- VPN Gateway de Azure
- GatewaySubnet
- Local Network Gateway
- Conexión IPsec/IKE clásica
- Alta disponibilidad
- BGP
- ExpressRoute
- Firewall centralizado
- DNS privado avanzado
- Monitoreo avanzado de la red híbrida

## Red local

| Elemento | Valor |
|---|---|
| LAN local | 192.168.0.0/24 |
| Proxmox | 192.168.0.99 |
| admin-01 | 192.168.0.201 |
| monitor-01 | 192.168.0.202 |
| Condición WAN | Detrás de CGNAT |

## Red Azure propuesta

| Elemento | Valor |
|---|---|
| VNet | 10.50.0.0/16 |
| Subnet workloads | 10.50.1.0/24 |

No se define `GatewaySubnet` en este alcance inicial porque no se usará Azure VPN Gateway.

## Arquitectura lógica

```text
Homelab local
192.168.0.0/24
        |
        | Tailscale / WireGuard overlay
        |
Azure VNet
10.50.0.0/16
```

## Componentes locales

| Componente | Propósito |
|---|---|
| admin-01 o VM dedicada futura | Nodo Tailscale local |
| Subnet router local | Anunciar `192.168.0.0/24` hacia el tailnet |
| Proxmox y VMs locales | Recursos accesibles desde Azure por la red privada |

## Componentes Azure

| Componente | Propósito |
|---|---|
| Resource Group | Agrupar recursos de la fase |
| Virtual Network | Red privada en Azure |
| Subnet workloads | Subnet para VMs o servicios de prueba |
| VM Linux gateway | Nodo Tailscale en Azure |
| NIC con IP forwarding | Permitir que la VM reenvíe tráfico entre Tailscale y la VNet |
| Route table | Enviar tráfico hacia la LAN local mediante la VM gateway |

## Nombres propuestos

| Recurso | Nombre |
|---|---|
| Resource Group | rg-homelab-network |
| VNet | vnet-homelab-azure |
| Workload subnet | snet-workloads |
| VM Tailscale Azure | az-ts-router-01 |
| NIC VM Tailscale | nic-az-ts-router-01 |
| Route table | rt-azure-to-homelab |

## Rutas previstas

| Origen | Destino | Ruta |
|---|---|---|
| Azure VNet | 192.168.0.0/24 | Vía VM Tailscale Azure |
| Homelab LAN | 10.50.0.0/16 | Vía nodo Tailscale local |

## Enfoque de implementación

### Lado local

Instalar Tailscale en un nodo local que pueda actuar como router hacia la LAN.

Opciones iniciales:

- `admin-01`
- una VM dedicada futura para red híbrida

En alcance básico se puede iniciar con `admin-01` para validar el concepto.

El nodo local anunciará:

```text
192.168.0.0/24
```

### Lado Azure

Crear una VM Linux pequeña en Azure dentro de la VNet `10.50.0.0/16`.

Esa VM tendrá Tailscale instalado y anunciará:

```text
10.50.0.0/16
```

Además, requerirá:

- IP forwarding habilitado en Azure para la NIC
- forwarding habilitado dentro del sistema operativo Linux
- route table en Azure para dirigir tráfico hacia `192.168.0.0/24`

## Validaciones esperadas

Desde Azure hacia homelab:

```text
ping 192.168.0.201
ping 192.168.0.202
ssh jocufe@192.168.0.201
```

Desde homelab hacia Azure:

```text
ping <IP privada de VM en Azure>
ssh <usuario>@<IP privada de VM en Azure>
```

Desde Tailscale:

```text
tailscale status
tailscale ping <nodo-remoto>
```

## Estado

Estado actual:

- Fase 5 iniciada
- Se detectó que el homelab está detrás de CGNAT
- Se ajustó el diseño base para usar Tailscale en lugar de VPN Site-to-Site clásica
- Implementación pendiente

## Pendientes

- Confirmar cuenta/tailnet de Tailscale
- Definir si el subnet router local será `admin-01` o una VM dedicada
- Crear recursos base en Azure
- Crear VM Linux en Azure para Tailscale
- Instalar y autenticar Tailscale en ambos lados
- Aprobar rutas anunciadas en Tailscale
- Configurar IP forwarding y rutas en Azure
- Validar conectividad entre `192.168.0.0/24` y `10.50.0.0/16`
