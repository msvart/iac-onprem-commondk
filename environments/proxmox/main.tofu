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

variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint (e.g. https://pve.example.dk:8006)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox VE API token (format: user@realm!tokenid=token-secret)"
  type        = string
  sensitive   = true
}

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
  domain      = "infra.example.dk"
  dns_servers = ["10.0.10.1", "1.1.1.1"]

  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExampleKeyHere ops@example.dk"
  ]

  vms = [
    # ==========================================
    # =            DOCKER HOSTS                =
    # ==========================================
    {
      name         = "docker-01"
      vm_id        = 110
      cores        = 4
      memory       = 8192
      disk_size    = 100
      ipv4_address = "10.0.10.10/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["docker", "prod"]
    },
    {
      name         = "docker-02"
      vm_id        = 111
      cores        = 4
      memory       = 8192
      disk_size    = 100
      ipv4_address = "10.0.10.11/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["docker", "prod"]
    },

    # ==========================================
    # =            KUBERNETES                  =
    # ==========================================
    {
      name         = "k8s-master-01"
      vm_id        = 120
      cores        = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.10.20/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "control-plane"]
    },
    {
      name         = "k8s-worker-01"
      vm_id        = 130
      cores        = 4
      memory       = 16384
      disk_size    = 100
      ipv4_address = "10.0.10.30/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "worker"]
    },
    {
      name         = "k8s-worker-02"
      vm_id        = 131
      cores        = 4
      memory       = 16384
      disk_size    = 100
      ipv4_address = "10.0.10.31/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["k8s", "worker"]
    },

    # ==========================================
    # =          STORAGE / BACKUP              =
    # ==========================================
    {
      name         = "nas-01"
      vm_id        = 140
      cores        = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.10.40/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["storage"]

      additional_disks = [
        { size = 2048 }
      ]
    },
    {
      name         = "backup-01"
      vm_id        = 150
      cores        = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.10.50/24"
      ipv4_gateway = "10.0.10.1"
      tags         = ["backup"]

      additional_disks = [
        { size = 1024 }
      ]
    },
  ]
}
