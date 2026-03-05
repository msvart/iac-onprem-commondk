variable "node_name" {
  description = "Proxmox VE node to deploy VMs on"
  type        = string
}

variable "template_id" {
  description = "Default template VM ID to clone from"
  type        = number
}

variable "datastore" {
  description = "Default storage / datastore ID"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Default network bridge"
  type        = string
  default     = "vmbr0"
}

variable "domain" {
  description = "Default search domain for cloud-init"
  type        = string
  default     = "localdomain"
}

variable "dns_servers" {
  description = "Default DNS servers for cloud-init"
  type        = list(string)
  default     = []
}

variable "ssh_public_keys" {
  description = "SSH public keys to inject via cloud-init"
  type        = list(string)
  default     = []
}

variable "vms" {
  description = "List of VMs to provision via clone from template"
  type = list(object({
    name        = string
    vm_id       = optional(number, null) # Explicit VM ID, null = auto-assign
    template_id = optional(number, null) # Override default template
    tags        = optional(list(string), [])
    on_boot     = optional(bool, true)

    # Compute
    cores   = number
    sockets = optional(number, 1)
    memory  = number # MB

    # Primary disk
    disk_size = number # GB
    datastore = optional(string, null) # Override default datastore

    # Additional disks
    additional_disks = optional(list(object({
      size      = number           # GB
      datastore = optional(string, null)
    })), [])

    # Network
    bridge  = optional(string, null) # Override default bridge
    vlan_id = optional(number, null)

    # Cloud-init
    ipv4_address = optional(string, null) # CIDR notation, e.g. "10.0.10.10/24" - null = DHCP
    ipv4_gateway = optional(string, null)
    dns_servers  = optional(list(string), null) # Override default DNS
  }))
}
