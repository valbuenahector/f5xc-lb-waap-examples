variable "f5xc_api_p12_file" {
  type        = string
  description = "Path to the API P12 file"
}

variable "f5xc_api_url" {
  type        = string
  description = "F5XC API URL"
  default     = "https://f5-amer-ent.console.ves.volterra.io/api"
}

variable "f5xc_tenant" {
  type        = string
  description = "F5XC Tenant Name"
  default     = "f5-amer-ent"
}

variable "f5xc_namespace" {
  type        = string
  description = "F5XC Namespace"
  default     = "h-valbuena"
}

variable "site_name" {
  type        = string
  description = "F5XC Site Name"
  default     = "hv-aws-us-east-1-ce"
}

variable "workload_name" {
  type        = string
  description = "Name of the workload"
  default     = "f5-ai-app-az-tf"
}

variable "container_image" {
  type        = string
  description = "Container image name"
  default     = "appworldregistry-c8gwcthfcvfnevfq.azurecr.io/ai-generated-app:latest"
}

variable "container_registry_name" {
  type        = string
  description = "Name of the pre-configured container registry"
  default     = "h-valbuena-acr"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 5000
}
