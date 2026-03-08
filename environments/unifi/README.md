# UniFi Network Configuration

Styrer VLAN- og netværkssegmentering på UniFi-controlleren via [`unifi_network`](../../modules/unifi_network)-modulet.

## Variabler

| Variabel | Beskrivelse |
|:---|:---|
| `unifi_api_url` | UniFi controller URL (f.eks. `https://unifi.example.dk`) |
| `unifi_username` | UniFi controller brugernavn |
| `unifi_password` | UniFi controller adgangskode (sensitive) |

## Netværksparametre

| Parameter | Type | Påkrævet | Beskrivelse |
|:---|:---|:---|:---|
| `name` | string | ja | Netværksnavn |
| `vlan_id` | number | ja | VLAN ID |
| `subnet` | string | ja | CIDR-notation (f.eks. `10.0.10.0/24`) |
| `purpose` | string | nej | `corporate` (default), `guest` eller `vlan-only` |
| `dhcp_enabled` | bool | nej | Aktiver DHCP (default: `true`) |
| `dhcp_start` | string | nej | DHCP range start |
| `dhcp_stop` | string | nej | DHCP range slut |
| `dhcp_dns` | list(string) | nej | DNS-servere til DHCP |
| `domain_name` | string | nej | Domænenavn for netværket |
| `igmp_snooping` | bool | nej | Aktiver IGMP snooping (default: `false`) |
| `network_group` | string | nej | Netværksgruppe (default: `LAN`) |

## Eksempelopsætning

```hcl
module "networks" {
  source = "../../modules/unifi_network"

  site = "default"

  networks = [
    {
      name         = "Management"
      vlan_id      = 10
      subnet       = "10.0.10.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.10.100"
      dhcp_stop    = "10.0.10.199"
      dhcp_dns     = ["10.0.10.1", "1.1.1.1"]
      domain_name  = "mgmt.example.dk"
    },
    {
      name         = "Servers"
      vlan_id      = 20
      subnet       = "10.0.20.0/24"
      dhcp_enabled = false
      domain_name  = "infra.example.dk"
    },
    {
      name         = "Users"
      vlan_id      = 30
      subnet       = "10.0.30.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.30.50"
      dhcp_stop    = "10.0.30.250"
      dhcp_dns     = ["10.0.10.1", "1.1.1.1"]
      domain_name  = "users.example.dk"
    },
    {
      name          = "IoT"
      vlan_id       = 40
      subnet        = "10.0.40.0/24"
      dhcp_enabled  = true
      dhcp_start    = "10.0.40.50"
      dhcp_stop     = "10.0.40.250"
      dhcp_dns      = ["1.1.1.1", "8.8.8.8"]
      igmp_snooping = true
    },
    {
      name         = "Guest"
      purpose      = "guest"
      vlan_id      = 50
      subnet       = "10.0.50.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.50.50"
      dhcp_stop    = "10.0.50.250"
      dhcp_dns     = ["1.1.1.1", "8.8.8.8"]
    },
    {
      name         = "DMZ"
      vlan_id      = 100
      subnet       = "10.0.100.0/24"
      dhcp_enabled = false
      domain_name  = "dmz.example.dk"
    },
  ]
}
```