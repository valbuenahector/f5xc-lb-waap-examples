resource "volterra_http_loadbalancer" "lb-app1-tf" {
  name      = "re-ce-lb-basic-lb"
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
      name      = volterra_origin_pool.private-pool-ce-site.name
      namespace = var.f5xc_namespace
    }
    weight = 1
  }

  advertise_on_public_default_vip = true
}
