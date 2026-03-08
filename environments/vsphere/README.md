# vSphere VM Configuration

Provisionerer virtuelle maskiner i VMware vSphere via [`vsphere_vm`](../../modules/vsphere_vm)-modulet. VM'er oprettes som clones fra templates med OS-customization.

## Variabler

| Variabel | Beskrivelse |
|:---|:---|
| `vsphere_server` | vCenter server-adresse |
| `vsphere_user` | vCenter brugernavn |
| `vsphere_password` | vCenter adgangskode (sensitive) |

## Modul parametre

| Parameter | Type | Påkrævet | Beskrivelse |
|:---|:---|:---|:---|
| `datacenter` | string | ja | vSphere datacenter-navn |
| `cluster` | string | ja | Compute cluster-navn |
| `datastore` | string | ja | Default datastore |
| `network` | string | ja | Default netværk / portgroup |
| `folder` | string | nej | VM-mappe |
| `domain` | string | nej | Domæne til OS customization |
| `dns_servers` | list(string) | nej | DNS-servere til OS customization |

## VM parametre

| Parameter | Type | Påkrævet | Beskrivelse |
|:---|:---|:---|:---|
| `name` | string | ja | VM-navn |
| `template` | string | ja | Template-navn at clone fra |
| `cpus` | number | ja | Antal vCPU'er |
| `memory` | number | ja | RAM i MB |
| `disk_size` | number | nej | Primær disk i GB (udelad = behold template-størrelse) |
| `network` | string | nej | Override default netværk |
| `ipv4_address` | string | nej | Statisk IP (udelad for DHCP) |
| `ipv4_netmask` | number | nej | Netmaske som prefix-længde (f.eks. `24`) |
| `ipv4_gateway` | string | nej | IPv4 gateway |
| `dns_servers` | list(string) | nej | Override default DNS |
| `domain` | string | nej | Override default domæne |
| `folder` | string | nej | Override default mappe |
| `annotation` | string | nej | VM-beskrivelse / note |
| `additional_disks` | list | nej | Ekstra diske (`size` i GB, valgfri `thin_provisioned`) |

## Eksempelopsætning

```hcl
module "vms" {
  source = "../../modules/vsphere_vm"

  datacenter  = "DC-CPH"
  cluster     = "Cluster-Prod"
  datastore   = "DS-SSD-01"
  network     = "VM-PROD-VLAN100"
  folder      = "Production"
  domain      = "infra.example.dk"
  dns_servers = ["10.0.100.2", "10.0.100.3"]

  vms = [
    # WEB SERVERS
    {
      name         = "web-01"
      template     = "ubuntu-2404-template"
      cpus         = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.100.10"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "Nginx reverse proxy + frontend"
    },
    {
      name         = "web-02"
      template     = "ubuntu-2404-template"
      cpus         = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.100.11"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "Nginx reverse proxy + frontend"
    },

    # DATABASE
    {
      name         = "db-01"
      template     = "ubuntu-2404-template"
      cpus         = 8
      memory       = 32768
      disk_size    = 100
      ipv4_address = "10.0.100.20"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "PostgreSQL primary"

      additional_disks = [
        { size = 500, thin_provisioned = true }
      ]
    },

    # MONITORING
    {
      name         = "mon-01"
      template     = "ubuntu-2404-template"
      cpus         = 2
      memory       = 4096
      disk_size    = 100
      ipv4_address = "10.0.100.30"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "zabbix proxy01"
    },

    # MAIL SERVER
    {
      name         = "mail-01"
      template     = "ubuntu-2404-template"
      cpus         = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.200.20"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.200.1"
      network      = "VM-DMZ-VLAN200"
      annotation   = "Postfix + Dovecot"

      additional_disks = [
        { size = 200, thin_provisioned = true }
      ]
    },
  ]
}
```