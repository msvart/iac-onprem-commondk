terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "~> 2.15.0"
    }
  }
}

# ==============================================================================
# Provider configuration
# ==============================================================================

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_user
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

# ==============================================================================
# Production VMs
# ==============================================================================

module "vms" {
  source = "../../modules/vsphere_vm"

  datacenter  = ""
  cluster     = ""
  datastore   = ""
  network     = ""
  folder      = ""
  domain      = "DOMAIN.EXAMPLE" //indsæt domain her
  dns_servers = []

  vms = [

  ]
}