resource "volterra_http_loadbalancer" "main" {
  name      = "re-ce-lb-waap-bot"
  namespace = var.f5xc_namespace
  domains   = [var.app_domain]

  https_auto_cert {
    add_hsts              = true
    http_redirect         = true
    no_mtls               = true
    enable_path_normalize = true
    tls_config {
      default_security = true
    }
  }

  // Default origin pool
  default_route_pools {
    pool {
      name      = volterra_origin_pool.ce_juiceshop.name
      namespace = volterra_origin_pool.ce_juiceshop.namespace
    }
    weight = 1
  }

  app_firewall {
    name      = volterra_app_firewall.main.name
    namespace = var.f5xc_namespace
  }

  // CDN Caching - enabled directly on the HTTP LB (April 2026+)
  // Replaces the previous approach of using a separate CDN LB and
  // CDN origin pool with L7 routing workaround.
  caching_policy {
    // Default cache action: respect origin Cache-Control headers,
    // fall back to 1 hour TTL if origin doesn't provide one
    default_cache_action {
      cache_ttl_default = "3600s"
    }
    // Custom cache rules for fine-grained control
    custom_cache_rule {
      cdn_cache_rules {
        name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-1.name
        namespace = var.f5xc_namespace
      }
      cdn_cache_rules {
        name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-2.name
        namespace = var.f5xc_namespace
      }
      cdn_cache_rules {
        name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-3a.name
        namespace = var.f5xc_namespace
      }
      cdn_cache_rules {
        name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-3b.name
        namespace = var.f5xc_namespace
      }
    }
  }

  advertise_on_public_default_vip = true
}
