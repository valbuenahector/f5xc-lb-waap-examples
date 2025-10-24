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

  default_route_pools {
    pool {
      name      = volterra_origin_pool.main.name
      namespace = var.f5xc_namespace
    }
    weight = 1
  }

  app_firewall {
    name      = volterra_app_firewall.main.name
    namespace = var.f5xc_namespace
  }

  advertise_on_public_default_vip = true
}
