# Proxmox VM Configuration

Provisionerer virtuelle maskiner i Proxmox VE via [`proxmox_vm`](../../modules/proxmox_vm)-modulet. VM'er oprettes som clones fra en cloud-init-template.

## Variabler

| Variabel | Beskrivelse |
|:---|:---|
| `proxmox_endpoint` | Proxmox VE API endpoint (f.eks. `https://pve.example.dk:8006`) |
| `proxmox_api_token` | API token i formatet `user@realm!tokenid=token-secret` (sensitive) |

## Modul parametre

| Parameter | Type | Påkrævet | Beskrivelse |
|:---|:---|:---|:---|
| `node_name` | string | ja | Proxmox-node at deploye på |
| `template_id` | number | ja | VM ID for cloud-init template |
| `datastore` | string | nej | Storage ID (default: `local-lvm`) |
| `bridge` | string | nej | Netværksbro (default: `vmbr0`) |
| `domain` | string | nej | Søgedomæne for cloud-init |
| `dns_servers` | list(string) | nej | DNS-servere for cloud-init |
| `ssh_public_keys` | list(string) | nej | SSH-nøgler til cloud-init |

## VM parametre

| Parameter | Type | Påkrævet | Beskrivelse |
|:---|:---|:---|:---|
| `name` | string | ja | VM-navn |
| `cores` | number | ja | Antal CPU-kerner |
| `memory` | number | ja | RAM i MB |
| `disk_size` | number | ja | Primær disk i GB |
| `vm_id` | number | nej | Eksplicit VM ID (auto hvis udeladt) |
| `template_id` | number | nej | Override default template |
| `tags` | list(string) | nej | Tags til VM |
| `on_boot` | bool | nej | Start ved boot (default: `true`) |
| `sockets` | number | nej | CPU-sockets (default: `1`) |
| `datastore` | string | nej | Override default datastore |
| `bridge` | string | nej | Override default netværksbro |
| `vlan_id` | number | nej | VLAN tag |
| `ipv4_address` | string | nej | Statisk IP i CIDR (f.eks. `10.0.10.10/24`), udelad for DHCP |
| `ipv4_gateway` | string | nej | IPv4 gateway |
| `dns_servers` | list(string) | nej | Override default DNS |
| `additional_disks` | list | nej | Ekstra diske (`size` i GB, valgfri `datastore`) |

## Eksempelopsætning

```hcl
module "vms" {
  source = "../../modules/proxmox_vm"

  node_name   = "pve-01"
  template_id = 9000
  datastore   = "local-lvm"
  bridge      = "vmbr0"
  domain      = "infra.example.dk"
  dns_servers = ["10.0.10.1", "1.1.1.1"]

  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExampleKeyHere ops@example.dk"
  ]

  vms = [
    # DOCKER HOSTS
    {
      name         = "docker-01"
      vm_id        = 110
      cores        = 4
      memory       = 8192
      disk_size    = 100
      ipv4_address = "10.0.10.10/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["docker", "prod"]
    },
    {
      name         = "docker-02"
      vm_id        = 111
      cores        = 4
      memory       = 8192
      disk_size    = 100
      ipv4_address = "10.0.10.11/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["docker", "prod"]
    },

    # KUBERNETES
    {
      name         = "k8s-master-01"
      vm_id        = 120
      cores        = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.10.20/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "control-plane"]
    },
    {
      name         = "k8s-worker-01"
      vm_id        = 130
      cores        = 4
      memory       = 16384
      disk_size    = 100
      ipv4_address = "10.0.10.30/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "worker"]
    },
    {
      name         = "k8s-worker-02"
      vm_id        = 131
      cores        = 4
      memory       = 16384
      disk_size    = 100
      ipv4_address = "10.0.10.31/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "worker"]
    },

    # STORAGE / BACKUP
    {
      name         = "nas-01"
      vm_id        = 140
      cores        = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.10.40/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["storage"]

      additional_disks = [
        { size = 2048 }
      ]
    },
    {
      name         = "backup-01"
      vm_id        = 150
      cores        = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.10.50/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["backup"]

      additional_disks = [
        { size = 1024 }
      ]
    },
  ]
}
```