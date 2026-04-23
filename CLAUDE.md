# F5XC LB WAAP Terraform Examples

Verified, runnable Terraform examples for F5 Distributed Cloud (F5XC) Load Balancing, WAAP (Web Application & API Protection), and Bot Defense across Regional Edge (RE) and Customer Edge (CE) deployments.

## Project Structure

```
examples/               # Each subdirectory is a standalone Terraform root module
  re-lb-basic/          # RE: basic HTTP LB
  re-lb-waap-bot/       # RE: LB + WAAP + Bot Defense
  re-lb-waap-bot-cdn/   # RE: LB + WAAP + Bot Defense + CDN
  ce-lb-basic/          # CE: basic HTTP LB
  ce-lb-waap-bot/       # CE: LB + WAAP + Bot Defense
  re-ce-lb-basic/       # RE-on-CE: basic HTTP LB
  re-ce-lb-waap-bot/    # RE-on-CE: LB + WAAP + Bot Defense
  re-ce-lb-waap-bot-cdn/# RE-on-CE: LB + WAAP + Bot + CDN
  ce-deploy-aws-smsv2/  # CE site deployment on AWS (placeholder)
  ce-vsite-k8s-volterra_workload/ # K8s workload management via API
common/                 # Shared assets (cdn-flow.png)
docs/                   # Per-example documentation (*.md)
schemas/                # Volterra provider schema snapshots (versioned)
scripts/                # Helper scripts (generate_volterra_schemas.sh)
openapi/                # OpenAPI specs (gitignored)
```

## Provider & Authentication

All examples use the `volterraedge/volterra` Terraform provider. Authentication requires:

```bash
export TF_VAR_f5xc_api_p12_file="<PATH_TO_P12>"
export VES_P12_PASSWORD="<P12_PASSWORD>"
```

Each example needs a `terraform.tfvars` with:
- `f5xc_api_url` - tenant console API URL
- `f5xc_tenant` - tenant name
- `f5xc_namespace` - target namespace
- `app_domain` - application domain
- `origin_dns_name` - origin server DNS
- `site_name` - (CE examples only)

## Canonical Sources (use ONLY these)

- Provider: https://registry.terraform.io/namespaces/volterraedge
- Modules:
  - volterraedge/app-delivery-network/volterra
  - volterraedge/web-app-security/volterra
  - volterraedge/secure-k8s-gateway/volterra
- Reference repo: https://github.com/f5devcentral/terraform-f5xc
- Docs: https://docs.cloud.f5.com/docs-v2

## Code Conventions

### File Naming
- Numbered prefix indicates dependency order: `1-origin.tf`, `2-waap-policy.tf`, `3-https-lb.tf`
- `provider.tf` - provider config + required_providers block (per example)
- `variables.tf` - all variable declarations (per example)
- No shared modules between examples; each is self-contained

### Style
- HCL2, Terraform >= 1.6.0 (note: some existing examples pin >= 0.12.9)
- Provider version pinned per example (currently 0.11.42-0.11.49 range)
- `//` comments for inline documentation
- `#` comments for deprecated/disabled arguments
- Resource names use pattern: `{type}-tf-{purpose}` (e.g., `pool-tf-juiceshop`, `waap-tf`)
- Variables use `var.f5xc_*` prefix for platform vars, plain names for app-specific

### Guardrails
1. Use ONLY `volterraedge/volterra` provider and listed modules
2. Copy argument names verbatim from provider docs - do NOT hallucinate resource arguments
3. If capability is unsupported, mark as `TODO` with doc reference
4. No secrets in code; use variables and env vars
5. If confidence < 75% on any resource/argument, flag for human review
6. Leave undocumented defaults unset

## Verification Commands

```bash
# Format check
terraform fmt -recursive

# Validate (per example)
cd examples/<name> && terraform init -upgrade && terraform validate

# Plan (per example)
terraform plan -refresh=false
```

## Key Resources Used

- `volterra_origin_pool` - backend origin servers
- `volterra_http_loadbalancer` - HTTP/HTTPS load balancers (includes inline CDN caching via `caching_policy` and Bot Defense)
- `volterra_app_firewall` - WAAP policies
- `volterra_cdn_cache_rule` - CDN caching rules (referenced by HTTP LB `caching_policy`)
- `volterra_cdn_loadbalancer` - standalone CDN load balancers (deprecated in favor of `caching_policy` on HTTP LB as of April 2026)
- `volterra_service_policy` / `volterra_service_policy_rule` - service policies

## Deployment Patterns

| Pattern | Advertise Method | Site Reference |
|---------|-----------------|----------------|
| RE (Regional Edge) | `advertise_on_public_default_vip = true` | None needed |
| CE (Customer Edge) | `advertise_custom` block with site reference | `site_name` variable |
| RE-on-CE | `advertise_on_public_default_vip = true` + CE origin | `site_name` on origin pool |

## Documentation

- Each example has a matching doc in `docs/<example-name>.md`
- Keep CHANGELOG.md updated with semver entries
- Commit message format: `feat(examples/<name>): description`

## Known Issues

- Provider version varies across examples (should be standardized to 0.11.49)
- `ce-deploy-aws-smsv2` is an empty placeholder directory
- Some deprecated arguments are commented out but retained for reference
- `re-ce-lb-waap-bot-cdn` origin pool uses a hardcoded private IP (should be a variable)
