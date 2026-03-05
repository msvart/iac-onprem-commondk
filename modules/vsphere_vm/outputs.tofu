output "vm_ids" {
  description = "Map of VM name to vSphere VM ID"
  value       = { for k, vm in vsphere_virtual_machine.this : k => vm.id }
}

output "vm_ips" {
  description = "Map of VM name to default IP address"
  value       = { for k, vm in vsphere_virtual_machine.this : k => vm.default_ip_address }
}

output "vm_names" {
  description = "List of all VM names"
  value       = [for k, vm in vsphere_virtual_machine.this : vm.name]
}
