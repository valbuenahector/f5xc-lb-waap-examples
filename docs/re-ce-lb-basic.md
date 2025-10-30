# F5XC CE HTTP Load Balancer

This example deploys a basic HTTP load balancer on an F5XC Customer Edge (CE) site.

## Provider Requirements

| Name | Version |
|------|---------|
| volterra | ~> 0.11.20 |

## Usage

1. Clone the repository
2. Navigate to the `examples/re-ce-lb-basic` directory
3. Create a `terraform.tfvars` file with your F5XC tenant credentials.
4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| f5xc_api_p12_file | Path to F5XC API credential file | `string` | n/a | yes |
| f5xc_api_url | F5XC API URL | `string` | n/a | yes |
| f5xc_tenant | F5XC tenant name | `string` | n/a | yes |
| f5xc_namespace | F5XC namespace | `string` | `"default"` | no |
| app_domain | Application domain | `string` | n/a | yes |
| site_name | Name of the F5XC site | `string` | n/a | yes |

## Verification

1. Log in to your F5XC console
2. Navigate to the `Load Balancers` section
3. Verify that the `ce-lb-basic` load balancer is created
4. Verify that the origin pool is created and healthy
5. Access your application using the specified domain
