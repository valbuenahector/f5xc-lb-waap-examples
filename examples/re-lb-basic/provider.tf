terraform {
    required_version = ">= 0.12.9, != 0.13.0"

    required_providers {
    volterra = {
        source = "volterraedge/volterra"
        version = "0.11.42"
    }
    }
}
provider "volterra" {
  url       = var.f5xc_api_url
  tenant    = var.f5xc_tenant
  # namespace = var.f5xc_namespace
  api_p12_file = var.f5xc_api_p12_file
}
