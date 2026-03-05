terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

data "cloudflare_zone" "zone" {
  filter = {
    name = var.root_domain
  }
}


resource "cloudflare_dns_record" "this" {
  for_each = { for r in var.dns_records : "${r.type}-${r.name}" => r }

  zone_id = try(data.cloudflare_zone.zone.zone_id, data.cloudflare_zone.zone.zone_id)
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  proxied = each.value.proxied
}