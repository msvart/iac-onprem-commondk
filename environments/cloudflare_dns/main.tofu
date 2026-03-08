terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {api_token = var.cloudflare_api_token}

module "dns" {
  source = "../../modules/cloudflare_dns"
  root_domain = "DOMAIN.EXAMPLE" //indsæt root domain her

  dns_records = [

  ]
}