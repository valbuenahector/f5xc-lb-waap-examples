# CE WAAP Example

This example shows how to create an HTTP Load Balancer on a Customer Edge (CE) site with a Web Application Firewall (WAF).

## Files

*   `1-origin.tf`: This file defines the origin pool, which is a group of servers that will handle the traffic for the load balancer.
*   `2-waap-policy.tf`: This file defines the WAAP policy that will be applied to the load balancer.
*   `3-https-lb.tf`: This file defines the HTTP load balancer itself, including the domain, HTTPS configuration with a custom certificate, WAAP policy, and default route to the origin pool.
*   `provider.tf`: This file configures the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file should be created by the user to provide values for the variables defined in `variables.tf`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| f5xc_api_p12_file | Path to F5XC API credential file | `string` | n/a | yes |
| f5xc_api_url | F5XC API URL | `string` | n/a | yes |
| f5xc_tenant | F5XC tenant name | `string` | n/a | yes |
| f5xc_namespace | F5XC namespace | `string` | `"default"` | no |
| app_domain | Application domain | `string` | n/a | yes |
| site_name | Name of the F5XC site | `string` | n/a | yes |
