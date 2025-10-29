# F5XC Terraform Examples

This repository provides verified, runnable Terraform examples for F5XC Load Balancing (LB), WAAP (Web Application & API Protection), and Bot Defense across RE (Regional Edge) and CE (Customer Edge) deployments, plus CE deploy automation & maintenance.

## Examples

*   [RE Load Balancer Basic](./docs/re-lb-basic.md)
*   [RE WAAP and Bot Defense](./docs/re-lb-waap-bot.md)
*   [RE WAAP, Bot Defense and CDN](./docs/re-lb-waap-bot-cdn.md)
*   [CE Load Balancer Basic](./docs/ce-lb-basic.md)
*   [CE WAAP](./docs/ce-lb-waap-bot.md)
*   [RE on CE Load Balancer Basic](./docs/re-ce-lb-basic.md)
*   [RE on CE WAAP and Bot Defense](./docs/re-ce-lb-waap-bot.md)
*   [RE on CE WAAP, Bot Defense and CDN](./docs/re-ce-lb-waap-bot-cdn.md)

## Prerequisites

Before running the examples, ensure you have the following environment variables set. These are required for the Terraform provider to authenticate with the F5XC API.

```bash
export TF_VAR_f5xc_api_p12_file="<PATH_TO_YOUR_P12_FILE>"
export VES_P12_PASSWORD="<YOUR_P12_FILE_PASSWORD>"
```

- `TF_VAR_f5xc_api_p12_file`: The absolute path to your F5XC API certificate file (`.p12`).
- `VES_P12_PASSWORD`: The password for your `.p12` certificate file.

## Getting Started

After setting the environment variables, you will need to create a `terraform.tfvars` file in each example's directory. This file will contain the necessary credentials and configuration for your F5XC tenant.

Create a file named `terraform.tfvars` with the following content:

```hcl
f5xc_api_url          = "https://<F5XC-TENANT>.console.ves.volterra.io/api"
f5xc_tenant           = "<F5XC-TENANT>"
f5xc_namespace        = "<NAMESPACE>"
app_domain            = "<APP_DOMAIN>"
site_name             = "<SITE_NAME>"
origin_dns_name       = "<ORIGIN_DNS_NAME>"
```

Replace the placeholder values with your actual F5XC tenant information.

## Disclaimer

This code is for testing and demonstration purposes only and should not be used in a production environment without proper review and adjustments. The code is provided "AS IS" without warranty of any kind.

---
