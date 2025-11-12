//==========================================================================
//Definition of the CDN Load Balancer
//==========================================================================
resource "volterra_cdn_loadbalancer" "cdn-distri-app1-tf" {
  name      = "cdn-distri-app1-tf"
  namespace = var.f5xc_namespace

  domains = ["cdn-${var.app_domain}"]
  
  https_auto_cert {
    add_hsts = true
    http_redirect = true
    #no_mtls = true
  }

  origin_pool {
    origin_request_timeout = "100s"

    public_name {
        dns_name = var.app_domain
        refresh_interval = "20"
    }

    origin_servers {
        public_name {
           dns_name = var.app_domain
           refresh_interval = "20"
        }
      }
    // One of the arguments from this list "no_tls use_tls" must be set
    # no_tls = true
    use_tls {
      use_host_header_as_sni = true
      tls_config {
          default_security = true
      }
      skip_server_verification = true
      no_mtls = true
    } 
  }
  custom_cache_rule {
    cdn_cache_rules {
      name = volterra_cdn_cache_rule.cdn-rules-app1-tf-1.name
      namespace = var.f5xc_namespace
    }
    cdn_cache_rules {
      name = volterra_cdn_cache_rule.cdn-rules-app1-tf-2.name
      namespace = var.f5xc_namespace
    }
    cdn_cache_rules {
      name = volterra_cdn_cache_rule.cdn-rules-app1-tf-3a.name
      namespace = var.f5xc_namespace
    }
    cdn_cache_rules {
      name = volterra_cdn_cache_rule.cdn-rules-app1-tf-3b.name
      namespace = var.f5xc_namespace
    }

  }

  active_service_policies {
    policies {
      name      = volterra_service_policy.cdn-sp.name
      namespace = var.f5xc_namespace
    }
  }
}
