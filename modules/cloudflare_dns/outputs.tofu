output "record_ids" {
  value = { for k,r in cloudflare_dns_record.this : k => r.id }
}

output "record_hostname" {
  value = { for k,r in cloudflare_dns_record.this : k => r.content }
}


