# F5 XC Regional Edge (RE) and Customer Edge (CE) Load Balancer with WAAP, Bot Defense, and CDN

This example demonstrates how to deploy a simple application on a Customer Edge (CE) site and protect it with F5 XC WAAP (Web Application and API Protection), Bot Defense, and CDN (Content Delivery Network) policies at the Regional Edge (RE).

## Prerequisites

- F5 XC Tenant
- F5 XC API Certificate
- AWS Account (for CE deployment)
- Terraform Cloud or Terraform CLI

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `f5xc_api_url` | F5 XC API URL | `string` | n/a | yes |
| `f5xc_tenant` | F5 XC Tenant Name | `string` | n/a | yes |
| `f5xc_namespace` | F5 XC Namespace | `string` | n/a | yes |
| `f5xc_api_p12_file` | Path to F5 XC API Certificate File | `string` | n/a | yes |
| `app_domain` | Application Domain | `string` | n/a | yes |
| `site_name` | F5 XC CE Site Name | `string` | n/a | yes |
| `origin_dns_name` | Origin DNS Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `lb_dns_name` | DNS name of the load balancer |

## How to run

1. Clone the repository.
2. `cd examples/re-ce-lb-waap-bot-cdn`
3. Create a `terraform.tfvars` file and populate it with the required variables.
4. `terraform init`
5. `terraform plan`
6. `terraform apply`

## Verification

1. Access the application using the `lb_dns_name` output.
2. Verify that the application is accessible.
3. Verify that the WAAP and Bot Defense policies are enforced.
4. Verify that the CDN is caching the static content.
