resource "volterra_origin_pool" "private-pool-ce-site" {
  name                   = "private-ip-ce-site"
  namespace              = var.f5xc_namespace
  endpoint_selection     = "LOCAL"
  loadbalancer_algorithm = "ROUND_ROBIN"

  origin_servers {
    private_ip {
      ip             = "10.84.102.251"
      site_locator {
        site {
          namespace = "system"
          name      = var.site_name
        }
      }
    }
    labels = {}
  }

  port = "80"
  no_tls = true

  # healthcheck {
  #   name = "http-health-check"
  #   http_health_check {
  #     path = "/"
  #   }
  #   healthy_threshold   = 1
  #   unhealthy_threshold = 1
  #   interval            = 5
  #   timeout             = 3
  # }
}
