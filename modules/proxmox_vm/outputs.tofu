output "vm_ids" {
  description = "Map of VM name to Proxmox VM ID"
  value       = { for k, vm in proxmox_virtual_environment_vm.this : k => vm.vm_id }
}

output "vm_ipv4" {
  description = "Map of VM name to primary IPv4 address"
  value       = { for k, vm in proxmox_virtual_environment_vm.this : k => vm.ipv4_addresses }
}

output "vm_names" {
  description = "List of all VM names"
  value       = [for k, vm in proxmox_virtual_environment_vm.this : vm.name]
}
