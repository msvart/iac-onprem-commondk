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