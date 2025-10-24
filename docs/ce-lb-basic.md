# CE Load Balancer Basic Example

This example shows how to create a basic HTTPS Load Balancer on a Customer Edge (CE) site.

## Prerequisites

Before running this example, you must create a `terraform.tfvars` file in the `examples/ce-lb-basic` directory with your F5XC tenant credentials. You can use the `terraform.tfvars.example` file in the same directory as a template.

## Files

*   `1-origin.tf`: This file defines the origin pool, which is a group of servers that will handle the traffic for the load balancer. It also includes a health check for the origin servers.
*   `2-https-lb.tf`: This file defines the HTTPS load balancer itself, including the domain, HTTPS configuration with a custom certificate, and default route to the origin pool.
*   `provider.tf`: This file configures the Volterra provider.
*   `variables.tf`: This file defines the variables used in the Terraform configuration.
*   `terraform.tfvars`: This file contains the values for the variables defined in `variables.tf`.
