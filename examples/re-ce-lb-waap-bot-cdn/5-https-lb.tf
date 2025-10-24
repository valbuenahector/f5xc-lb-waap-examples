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

  // CDN Route
  routes {
      simple_route {
          http_method = "ANY"
          path {
              regex = ".+\\.(?:jpg|jpeg|png|css|js|gif|webp|svg)(?:\\?.*)?$"
          }
          origin_pools {
              pool {
                  name = volterra_origin_pool.pool-tf-cdn.name
                  namespace = var.f5xc_namespace
              }

          }
      }
  }

  app_firewall {
    name      = volterra_app_firewall.main.name
    namespace = var.f5xc_namespace
  }

  // Default Route
  routes {
    simple_route {
      path {
        prefix = "/"
      }
      origin_pools {
        pool {
          name      = volterra_origin_pool.ce_juiceshop.name
          namespace = volterra_origin_pool.ce_juiceshop.namespace
        }
        weight = 1
      }
    }
  }

  advertise_on_public_default_vip = true
}
