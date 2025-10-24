variable "f5xc_api_p12_file" {
  description = "Path to F5XC API credential file"
  type        = string
}

variable "f5xc_api_url" {
  description = "F5XC API URL"
  type        = string
}

variable "f5xc_tenant" {
  description = "F5XC tenant name"
  type        = string
}

variable "f5xc_namespace" {
  description = "F5XC namespace"
  type        = string
  default     = "default"
}

variable "app_domain" {
  description = "Application domain"
  type        = string
}

variable "site_name" {
  description = "Name of the F5XC site"
  type        = string
}
