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

  datacenter  = "DC-CPH"
  cluster     = "Cluster-Prod"
  datastore   = "DS-SSD-01"
  network     = "VM-PROD-VLAN100"
  folder      = "Production"
  domain      = "infra.example.dk"
  dns_servers = ["10.0.100.2", "10.0.100.3"]

  vms = [
    # ==========================================
    # =              WEB SERVERS               =
    # ==========================================
    {
      name         = "web-01"
      template     = "ubuntu-2404-template"
      cpus         = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.100.10"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "Nginx reverse proxy + frontend"
    },
    {
      name         = "web-02"
      template     = "ubuntu-2404-template"
      cpus         = 4
      memory       = 8192
      disk_size    = 50
      ipv4_address = "10.0.100.11"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "Nginx reverse proxy + frontend"
    },

    # ==========================================
    # =               DATABASE                 =
    # ==========================================
    {
      name         = "db-01"
      template     = "ubuntu-2404-template"
      cpus         = 8
      memory       = 32768
      disk_size    = 100
      ipv4_address = "10.0.100.20"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "PostgreSQL primary"

      additional_disks = [
        { size = 500, thin_provisioned = true }
      ]
    },

    # ==========================================
    # =              MONITORING                =
    # ==========================================
    {
      name         = "mon-01"
      template     = "ubuntu-2404-template"
      cpus         = 2
      memory       = 4096
      disk_size    = 100
      ipv4_address = "10.0.100.30"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.100.1"
      annotation   = "Grafana + Prometheus"
    },

    # ==========================================
    # =              MAIL SERVER               =
    # ==========================================
    {
      name         = "mail-01"
      template     = "ubuntu-2404-template"
      cpus         = 2
      memory       = 4096
      disk_size    = 50
      ipv4_address = "10.0.200.20"
      ipv4_netmask = 24
      ipv4_gateway = "10.0.200.1"
      network      = "VM-DMZ-VLAN200"
      annotation   = "Postfix + Dovecot"

      additional_disks = [
        { size = 200, thin_provisioned = true }
      ]
    },
  ]
}
