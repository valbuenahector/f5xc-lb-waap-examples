# AAAA DNS Load Balancer — GTM AAAA Wide-IP equivalent.
# fallback_pool activates when no rule matches the query (confirmed by F5XC
# docs: "If no pool matches, then this pool will be the fallback pool.").
# Needs Verification: whether it also activates when a rule matches but all
# of that pool's members are unhealthy (the scenario closer to GTM's
# per-pool fallback-ip behavior) — see docs/dns-lb-gtm-fallback.md.
resource "volterra_dns_load_balancer" "example" {
  name        = "aaaa-tf-gtm-fallback-lb"
  namespace   = var.f5xc_namespace
  record_type = "AAAA"

  fallback_pool {
    name      = volterra_dns_lb_pool.fallback.name
    namespace = var.f5xc_namespace
  }

  rule_list {
    rules {
      pool {
        name      = volterra_dns_lb_pool.primary.name
        namespace = var.f5xc_namespace
      }
    }
  }
}
