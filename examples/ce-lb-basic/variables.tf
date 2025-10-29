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

variable "site_name" {
  type        = string
  description = "CE site name"
}

variable "app_domain" {
  type        = string
  description = "Application domain"
}
