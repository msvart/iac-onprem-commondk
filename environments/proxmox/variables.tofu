variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint (e.g. https://pve.example.dk:8006)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox VE API token (format: user@realm!tokenid=token-secret)"
  type        = string
  sensitive   = true
}