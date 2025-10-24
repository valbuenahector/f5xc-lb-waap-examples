terraform {
  required_version = ">= 1.6.0"
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "~> 0.11"
    }
  }
}

provider "volterra" {
  url       = var.f5xc_api_url
  tenant    = var.f5xc_tenant
  api_p12_file = var.f5xc_api_p12_file
}
