# F5XC CE HTTP Load Balancer

This example deploys a basic HTTP load balancer on an F5XC Customer Edge (CE) site.

## Prerequisites

- F5XC account
- F5XC API certificate
- F5XC CE site deployed

## Usage

1. Clone the repository
2. Navigate to the `examples/re-ce-lb-basic` directory
3. Create a `terraform.tfvars` file with the following variables:

```
f5xc_api_p12_file = "<PATH_TO_YOUR_P12_FILE>"
f5xc_api_url      = "<YOUR_F5XC_API_URL>"
f5xc_tenant       = "<YOUR_F5XC_TENANT>"
f5xc_namespace    = "default"
app_domain        = "<YOUR_APP_DOMAIN>"
site_name         = "<YOUR_CE_SITE_NAME>"
```

4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Verification

1. Log in to your F5XC console
2. Navigate to the `Load Balancers` section
3. Verify that the `ce-lb-basic` load balancer is created
4. Verify that the origin pool is created and healthy
5. Access your application using the specified domain
