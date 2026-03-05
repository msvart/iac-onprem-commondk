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
  for_each = { for idx, r in var.dns_records : "${r.type}-${r.name}-${idx}" => r }

  zone_id = data.cloudflare_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  content  = each.value.content
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = each.value.priority
}