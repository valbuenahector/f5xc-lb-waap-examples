resource "volterra_cdn_loadbalancer" "cdn_distri_app1_tf" {
  name      = "cdn-distri-app1-tf"
  namespace = var.f5xc_namespace

  domains = ["apptf1-cdn.xc.hvf5lab.com"]

  https_auto_cert {
    http_redirect = true
    add_hsts      = true
  }

  origin_pool {
    origin_request_timeout = "100s"

    public_name {
        dns_name = "cdnapp.hvf5lab.com"
        refresh_interval = "20"
    }

    origin_servers {
        public_name {
           dns_name = "cdnapp.hvf5lab.com"
           refresh_interval = "20"
        }
      }
    // One of the arguments from this list "no_tls use_tls" must be set
    no_tls = true
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
}
