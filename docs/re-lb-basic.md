# RE Load Balancer Basic Example

This example shows how to create a basic HTTP Load Balancer on a Regional Edge (RE) site.

## Prerequisites

Before running this example, you must create a `terraform.tfvars` file in the `examples/re-lb-basic` directory with your F5XC tenant credentials. You can use the `terraform.tfvars.example` file in the same directory as a template.

## Provider Requirements

| Name | Version |
|------|---------|
| volterra | ~> 0.11.20 |

## Files

*   `1-origin.tf`: This file defines the origin pool, which is a group of servers that will handle the traffic for the load balancer.
*   `2-https-lb.tf`: This file defines the HTTP load balancer itself, including the domain, HTTPS configuration, and default route to the origin pool.
*   `provider.tf`: This file configures the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file contains the values for the variables defined in `variables.tf`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| f5xc_api_p12_file | Path to F5XC API credential file | `string` | n/a | yes |
| f5xc_api_url | F5XC API URL | `string` | n/a | yes |
| f5xc_tenant | F5XC tenant name | `string` | n/a | yes |
| f5xc_namespace | F5XC namespace | `string` | `"default"` | no |
| app_domain | Application domain | `string` | n/a | yes |
| origin_dns_name | Origin DNS name | `string` | n/a | yes |
