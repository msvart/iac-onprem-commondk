variable "vsphere_server" {
  description = "vCenter server address"
  type        = string
}

variable "vsphere_user" {
  description = "vCenter username"
  type        = string
}

variable "vsphere_password" {
  description = "vCenter password"
  type        = string
  sensitive   = true
}