variable "site" {
  description = "UniFi site name"
  type        = string
  default     = "default"
}

variable "networks" {
  description = "List of UniFi networks / VLANs to create"
  type = list(object({
    name    = string
    purpose = optional(string, "corporate") # corporate, guest, vlan-only
    vlan_id = number
    subnet  = string # CIDR notation, e.g. "10.0.10.0/24"

    # DHCP
    dhcp_enabled = optional(bool, true)
    dhcp_start   = optional(string, null)
    dhcp_stop    = optional(string, null)
    dhcp_dns     = optional(list(string), [])

    # Misc
    domain_name    = optional(string, null)
    igmp_snooping  = optional(bool, false)
    network_group  = optional(string, "LAN")
  }))
}
