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