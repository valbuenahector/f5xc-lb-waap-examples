variable "f5xc_api_p12_file" {
    type = string
}
variable "f5xc_api_url" {
    type = string
}
variable "f5xc_tenant" {
    type = string
}
variable "f5xc_namespace" {
    type = string
}

variable "primary_member_1_ipv6" {
  type        = string
  description = "First (highest-priority) primary pool member IPv6 address — GTM AAAA pool member #1 equivalent"
}

variable "primary_member_2_ipv6" {
  type        = string
  description = "Second (lower-priority) primary pool member IPv6 address — GTM AAAA pool member #2 equivalent"
}

variable "fallback_ipv6" {
  type        = string
  description = "GTM pool 'fallback-ip' equivalent — answered only when no rule matches the query (see docs/dns-lb-gtm-fallback.md for the Needs-Verification scope caveat)"
}

variable "dns_zone_name" {
  type        = string
  description = "Existing F5XC DNS zone this record set belongs to (zone itself is out of scope for this example — see docs/dns-lb-gtm-fallback.md)"
}
