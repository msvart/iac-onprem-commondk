terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

# ==============================================================================
# Provider configuration
# ==============================================================================

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
}

# ==============================================================================
# Infrastructure VMs
# ==============================================================================

module "vms" {
  source = "../../modules/proxmox_vm"

  node_name   = "pve-01"
  template_id = 9000
  datastore   = "local-lvm"
  bridge      = "vmbr0"
  domain      = "DOMAIN.EXAMPLE" //indsæt domain her
  dns_servers = []

  ssh_public_keys = []

  vms = [

  ]
}