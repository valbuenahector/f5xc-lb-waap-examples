# CE WAAP Example

This example shows how to create an HTTP Load Balancer on a Customer Edge (CE) site with a Web Application Firewall (WAF).

## Prerequisites

Before running this example, you must create a `terraform.tfvars` file in the `examples/ce-lb-waap-bot` directory with your F5XC tenant credentials. You can use the `terraform.tfvars.example` file in the same directory as a template.

You will need to provide the following variables:
- `f5xc_api_p12_file`: Path to your F5XC API certificate file.
- `f5xc_api_url`: Your F5XC tenant URL.
- `f5xc_tenant`: Your F5XC tenant name.
- `f5xc_namespace`: The F5XC namespace to deploy the resources in.
- `app_domain`: The domain for your application (e.g., `ceonly.hvf5lab.com`).
- `site_name`: The name of your CE site (e.g., `hv-aws-us-east-1-ce`).

## Files

*   `1-origin.tf`: This file defines the origin pool, which is a group of servers that will handle the traffic for the load balancer.
*   `2-waap-policy.tf`: This file defines the WAAP policy that will be applied to the load balancer.
*   `3-https-lb.tf`: This file defines the HTTP load balancer itself, including the domain, HTTPS configuration with a custom certificate, WAAP policy, and default route to the origin pool.
*   `provider.tf`: This file configures the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file should be created by the user to provide values for the variables defined in `variables.tf`.
