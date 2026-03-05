variable "dns_records" {
  description = "Cloudflare DNS records"
  type = list(object({
    name = string
    type = string
    content = string
    ttl = optional(number, 1) # sætter TTL til 1 hvis ingenting er defined
    proxied  = optional(bool, false)
    priority = optional(number, null)
  }))
}

variable "root_domain" {
  type = string
  default = null
}
