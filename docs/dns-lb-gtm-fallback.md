# dns-lb-gtm-fallback

AAAA DNS Load Balancer with a dedicated fallback pool — the F5XC equivalent of a BIG-IP GTM
AAAA pool's `fallback-ip` behavior, converting a priority-ordered primary pool with a
last-resort fallback pool referenced via `fallback_pool`.

## Prerequisites

- F5XC tenant with DNS Management enabled
- An existing DNS Zone in F5XC if you plan to bind the load balancer into a live rrset
  (see `3-zone-record.tf`, left commented by default — see Known Limitations below)
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
| `terraform.tfvars` | Generic placeholder values (not customer-specific) |
| `1-dns-pools.tf` | Primary AAAA pool (priority-ordered members) + fallback AAAA pool |
| `2-dns-lb.tf` | AAAA `volterra_dns_load_balancer` referencing both pools |
| `3-zone-record.tf` | Optional, commented-out zone rrset binding |

## Inputs

| Name | Description |
|---|---|
| `f5xc_api_p12_file` | Path to API client certificate (p12) |
| `f5xc_api_url` | F5XC tenant API URL |
| `f5xc_tenant` | F5XC tenant name |
| `f5xc_namespace` | Target namespace |
| `primary_member_1_ipv6` | Highest-priority primary pool member |
| `primary_member_2_ipv6` | Lower-priority primary pool member |
| `fallback_ipv6` | GTM pool `fallback-ip` equivalent |
| `dns_zone_name` | Existing DNS zone name (only used if `3-zone-record.tf` is uncommented) |

## GTM → F5XC Mapping

| GTM concept | F5XC equivalent |
|---|---|
| AAAA pool, priority load-balancing mode | `volterra_dns_lb_pool.aaaa_pool` with `members.priority` |
| Pool `fallback-ip` / `fallback-mode` | Dedicated `volterra_dns_lb_pool` referenced by `volterra_dns_load_balancer.fallback_pool` |

## Known Limitations / Needs Verification

- **`fallback_pool` trigger scope is not fully confirmed.** F5XC docs confirm it activates
  "if no pool matches" (a rule-matching failure). It is *not* confirmed whether it also
  activates when a rule matches but every member of that rule's pool is unhealthy — the
  scenario closer to GTM's per-pool `fallback-ip`. Confirm with F5 before treating this as a
  full behavioral equivalent.
- **`aaaa_pool` has no `health_check` / `disable_health_check` argument** in the pinned
  provider schemas (0.11.39–0.11.49), unlike `a_pool`, which has both. AAAA member health
  evaluation should be confirmed with F5 as either a real product limitation or a
  provider-modeling gap.
- `3-zone-record.tf` is left commented out: binding into a live DNS Zone's rrset can conflict
  with console-managed records in the same zone/group. Uncomment and adapt only after
  confirming the target zone/group ownership model.

## Related

- Ally Bank migration questions this example was built to answer:
  `projects/ally-bank/migration-big-gtm-to-f5xc-dns/output/gtm-to-f5xc-dns-questions-response.md`
  in the F5 workspace.
