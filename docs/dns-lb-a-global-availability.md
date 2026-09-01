# dns-lb-a-global-availability

A-record DNS Load Balancer with a priority-ordered primary pool and a dedicated fallback pool
— the F5XC equivalent of a BIG-IP GTM `a` pool in `global-availability` load-balancing mode with
a `fallback-ip`/`fallback-mode` set. This is the pattern for the "Ready to Migrate" category in
Ally Bank's per-WideIP migration tracker: no topology steering, no `return-to-dns`, no
`pools-cname` apex flattening, no GTM persistence — a straight priority-failover conversion.

## Prerequisites

- F5XC tenant with DNS Management enabled
- An existing DNS Zone in F5XC if you plan to bind the load balancer into a live rrset (not
  included in this example — see `dns-lb-gtm-fallback/3-zone-record.tf` for the pattern)
- Terraform >= 0.12.9, != 0.13.0

## Provider Requirements

| Provider | Source | Version |
|---|---|---|
| volterra | volterraedge/volterra | 0.11.49 |

## Files

| File | Purpose |
|---|---|
| `provider.tf` | Volterra provider configuration |
| `variables.tf` | Input variable declarations |
| `terraform.tfvars` | Generic placeholder values (RFC 5737 documentation-range IPs, not customer-specific) |
| `1-dns-pools.tf` | Primary A pool (priority-ordered members) + fallback A pool |
| `2-dns-lb.tf` | A-record `volterra_dns_load_balancer` referencing both pools |

## Inputs

| Name | Description |
|---|---|
| `f5xc_api_p12_file` | Path to API client certificate (p12) |
| `f5xc_api_url` | F5XC tenant API URL |
| `f5xc_tenant` | F5XC tenant name |
| `f5xc_namespace` | Target namespace |
| `primary_member_1_ipv4` | Highest-priority primary pool member |
| `primary_member_2_ipv4` | Lower-priority primary pool member |
| `fallback_ipv4` | GTM pool `fallback-ip` equivalent |

## GTM → F5XC Mapping

| GTM concept | F5XC equivalent |
|---|---|
| `a` pool, `global-availability` load-balancing mode | `volterra_dns_lb_pool.a_pool` with `members.priority` (first-available-in-order) |
| Pool `fallback-ip` / `fallback-mode` | Dedicated `volterra_dns_lb_pool` referenced by `volterra_dns_load_balancer.fallback_pool` |
| `gtm wideip a` | `volterra_dns_load_balancer` with `record_type = "A"` |

Confirmed against the actual Ally config: e.g. `gtm wideip a alor-secureauto.eglb.ally.com` →
`gtm pool a pool.alor-secureauto.ally.com` (`load-balancing-mode global-availability`,
`fallback-mode fallback-ip`, 2 members) is a "Ready to Migrate" row in the tracker and maps
1:1 onto this example's shape (this example itself uses placeholder IPs, not Ally's real
member addresses).

## Known Limitations / Needs Verification

- **`fallback_pool` trigger scope is not fully confirmed** — same open item as
  `dns-lb-gtm-fallback`: F5XC docs confirm it activates "if no pool matches" (a rule-matching
  failure); not confirmed whether it also activates when a rule matches but every member of
  that pool is unhealthy, the closer analog to GTM's per-pool `fallback-ip`. Confirm with F5.
- `a_pool` *does* expose `health_check` / `disable_health_check` (unlike `aaaa_pool` — see
  `dns-lb-gtm-fallback.md`), but this example leaves both unset (undocumented default) per the
  repo's "leave undocumented defaults unset" guardrail. Set `disable_health_check = false` and
  attach a `volterra_dns_lb_health_check` resource before production use if member health
  checking is required.
- No zone-record binding is included in this example (see `dns-lb-gtm-fallback/3-zone-record.tf`
  for the commented-out pattern and its own caveats about console-managed rrsets).

## Related

- Per-WideIP migration tracker this example supports:
  `projects/ally-bank/migration-big-gtm-to-f5xc-dns/output/ally-gtm-wideip-f5xc-migration-tracker-2026-08-31.xlsx`
  in the F5 workspace — 113 "Ready to Migrate" A-record WideIPs use this exact pattern.
- Sibling AAAA example: `dns-lb-gtm-fallback` (same fallback-pool pattern, AAAA record type).
