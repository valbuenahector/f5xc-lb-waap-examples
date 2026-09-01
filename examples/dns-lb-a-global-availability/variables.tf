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

variable "primary_member_1_ipv4" {
  type        = string
  description = "First (highest-priority) primary pool member IPv4 address — GTM 'a' pool member #1 equivalent"
}

variable "primary_member_2_ipv4" {
  type        = string
  description = "Second (lower-priority) primary pool member IPv4 address — GTM 'a' pool member #2 equivalent"
}

variable "fallback_ipv4" {
  type        = string
  description = "GTM pool 'fallback-ip' equivalent — answered only when no rule matches the query (see docs/dns-lb-a-global-availability.md for the Needs-Verification scope caveat)"
}
