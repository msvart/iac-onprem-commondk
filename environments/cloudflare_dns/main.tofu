terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

variable "cloudflare_api_token" {
  type = string
}

provider "cloudflare" {api_token = var.cloudflare_api_token}

module "dns" {
  source = "../../modules/cloudflare_dns"
  root_domain = "example.dk"

  dns_records = [
  # ==========================================
  # =                  WEB                   =
  # ==========================================
  { name = "@",     type = "A",     content = "192.168.1.10", ttl = 1,   proxied = true  },
  { name = "www",   type = "CNAME", content = "example.dk",   ttl = 1,   proxied = true  },
  { name = "app",   type = "A",     content = "192.168.1.15", ttl = 300, proxied = true  },

  # ==========================================
  # =                  MAIL                  =
  # ==========================================
  { name = "mail",    type = "A",   content = "192.168.1.20", ttl = 300,  proxied = false },
  { name = "@",       type = "MX",  content = "mail.example.dk",  ttl = 300, proxied = false, priority = 10 },
  { name = "@",       type = "MX",  content = "mail2.example.dk", ttl = 300, proxied = false, priority = 20 },
  { name = "@",       type = "TXT", content = "v=spf1 mx ~all",           proxied = false },
  { name = "_dmarc",  type = "TXT", content = "v=DMARC1; p=none;",        proxied = false },
  { name = "imap",    type = "CNAME", content = "mail.example.dk",        proxied = false },
  { name = "smtp",    type = "CNAME", content = "mail.example.dk",        proxied = false },

  # ==========================================
  # =             VERIFICATION               =
  # ==========================================
  { name = "@",     type = "TXT", content = "google-site-verification=abc123", proxied = false },
  { name = "@",     type = "TXT", content = "MS=ms12345678",                    proxied = false },

  # ==========================================
  # =                SERVICES                =
  # ==========================================
  { name = "vpn",   type = "A",     content = "192.168.1.30", ttl = 300, proxied = false },
  { name = "nas",   type = "A",     content = "192.168.1.40", ttl = 300, proxied = false },
  { name = "api",   type = "CNAME", content = "app.example.dk", ttl = 1, proxied = true  },

  # ==========================================
  # =                  IPV6                  =
  # ==========================================
  { name = "ipv6",  type = "AAAA", content = "2001:db8::10", ttl = 300, proxied = false }
]
}
