terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = "~> 0.41"
    }
  }
}

# ==============================================================================
# Provider configuration
# ==============================================================================

variable "unifi_api_url" {
  description = "UniFi controller URL (e.g. https://unifi.example.dk)"
  type        = string
}

variable "unifi_username" {
  description = "UniFi controller username"
  type        = string
}

variable "unifi_password" {
  description = "UniFi controller password"
  type        = string
  sensitive   = true
}

provider "unifi" {
  api_url        = var.unifi_api_url
  username       = var.unifi_username
  password       = var.unifi_password
  allow_insecure = true
}

# ==============================================================================
# Network / VLAN configuration
# ==============================================================================

module "networks" {
  source = "../../modules/unifi_network"

  site = "DOMAIN.EXAMPLE" //indsæt root dommain her

  networks = [

  ]
}


/*

    # ==========================================
    # =             EKSEMPELOPSÆTNING                 =
    # ==========================================
module "networks" {
  source = "../../modules/unifi_network"

  site = "DOMAIN.EXAMPLE" //indsæt root dommain her

  networks = [
    # ==========================================
    # =             MANAGEMENT                 =
    # ==========================================
    {
      name         = "Management"
      vlan_id      = 10
      subnet       = "10.0.10.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.10.100"
      dhcp_stop    = "10.0.10.199"
      dhcp_dns     = ["10.0.10.1", "1.1.1.1"]
      domain_name  = "mgmt.example.dk"
    },

    # ==========================================
    # =              SERVERS                   =
    # ==========================================
    {
      name         = "Servers"
      vlan_id      = 20
      subnet       = "10.0.20.0/24"
      dhcp_enabled = false
      domain_name  = "infra.example.dk"
    },

    # ==========================================
    # =            WORKSTATIONS                =
    # ==========================================
    {
      name         = "Users"
      vlan_id      = 30
      subnet       = "10.0.30.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.30.50"
      dhcp_stop    = "10.0.30.250"
      dhcp_dns     = ["10.0.10.1", "1.1.1.1"]
      domain_name  = "users.example.dk"
    },

    # ==========================================
    # =                 IOT                    =
    # ==========================================
    {
      name          = "IoT"
      vlan_id       = 40
      subnet        = "10.0.40.0/24"
      dhcp_enabled  = true
      dhcp_start    = "10.0.40.50"
      dhcp_stop     = "10.0.40.250"
      dhcp_dns      = ["1.1.1.1", "8.8.8.8"]
      igmp_snooping = true
    },

    # ==========================================
    # =                GUEST                   =
    # ==========================================
    {
      name         = "Guest"
      purpose      = "guest"
      vlan_id      = 50
      subnet       = "10.0.50.0/24"
      dhcp_enabled = true
      dhcp_start   = "10.0.50.50"
      dhcp_stop    = "10.0.50.250"
      dhcp_dns     = ["1.1.1.1", "8.8.8.8"]
    },

    # ==========================================
    # =                 DMZ                    =
    # ==========================================
    {
      name         = "DMZ"
      vlan_id      = 100
      subnet       = "10.0.100.0/24"
      dhcp_enabled = false
      domain_name  = "dmz.example.dk"
    },
  ]
}


 */