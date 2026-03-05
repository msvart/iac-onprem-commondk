variable "datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "cluster" {
  description = "vSphere compute cluster name"
  type        = string
}

variable "datastore" {
  description = "Default datastore name"
  type        = string
}

variable "network" {
  description = "Default network / portgroup name"
  type        = string
}

variable "folder" {
  description = "Default VM folder path (optional)"
  type        = string
  default     = null
}

variable "domain" {
  description = "Default domain for OS customization"
  type        = string
  default     = "localdomain"
}

variable "dns_servers" {
  description = "Default DNS servers for OS customization"
  type        = list(string)
  default     = []
}

variable "vms" {
  description = "List of VMs to provision via clone from template"
  type = list(object({
    name     = string
    template = string
    cpus     = number
    memory   = number # MB

    disk_size = optional(number, null) # Primary disk size in GB - null = keep template size

    additional_disks = optional(list(object({
      size             = number           # GB
      thin_provisioned = optional(bool, true)
    })), [])

    network      = optional(string, null) # Override default network
    ipv4_address = optional(string, null) # null = DHCP
    ipv4_netmask = optional(number, null)
    ipv4_gateway = optional(string, null)
    dns_servers  = optional(list(string), null) # Override default DNS
    domain       = optional(string, null)       # Override default domain
    folder       = optional(string, null)       # Override default folder
    annotation   = optional(string, null)
  }))
}
