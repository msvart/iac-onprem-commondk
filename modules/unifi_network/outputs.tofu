output "network_ids" {
  description = "Map of network name to UniFi network ID"
  value       = { for k, n in unifi_network.this : k => n.id }
}

output "network_subnets" {
  description = "Map of network name to subnet CIDR"
  value       = { for k, n in unifi_network.this : k => n.subnet }
}

output "network_vlan_ids" {
  description = "Map of network name to VLAN ID"
  value       = { for k, n in unifi_network.this : k => n.vlan_id }
}
