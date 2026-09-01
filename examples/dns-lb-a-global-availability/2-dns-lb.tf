# A-record DNS Load Balancer — GTM "wideip a" equivalent for the "Ready to
# Migrate" category in Ally Bank's migration tracker: no topology steering,
# no return-to-dns, no pools-cname apex flattening, no GTM persistence.
# record_type = "A" confirmed against volterra_dns_load_balancer schema
# (schemas/0.11.49/volterra_dns_load_balancer.json).
resource "volterra_dns_load_balancer" "example" {
  name        = "a-tf-ready-to-migrate-lb"
  namespace   = var.f5xc_namespace
  record_type = "A"

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
