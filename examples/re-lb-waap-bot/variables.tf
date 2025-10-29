variable "f5xc_api_p12_file" {
    type = string
}
variable "f5xc_api_url" {
    type = string
}
variable "f5xc_tenant"      { 
    type = string
}
variable "f5xc_namespace"   { 
    type = string
}

variable "app_domain" {
  type        = string
  description = "Application domain"
}

variable "origin_dns_name" {
  type        = string
  description = "Origin DNS name"
}
