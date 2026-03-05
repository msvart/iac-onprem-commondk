terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "~> 0.41"
    }
  }
}

# ==============================================================================
# Locals
# ==============================================================================

locals {
  network_map = { for n in var.networks : n.name => n }
}

# ==============================================================================
# UniFi Networks / VLANs
# ==============================================================================

resource "unifi_network" "this" {
  for_each = local.network_map

  site = var.site

  name          = each.value.name
  purpose       = each.value.purpose
  vlan_id       = each.value.vlan_id
  subnet        = each.value.subnet
  network_group = each.value.network_group

  # DHCP
  dhcp_enabled = each.value.dhcp_enabled
  dhcp_start   = each.value.dhcp_start
  dhcp_stop    = each.value.dhcp_stop
  dhcp_dns     = each.value.dhcp_dns

  # Misc
  domain_name   = each.value.domain_name
  igmp_snooping = each.value.igmp_snooping
}
