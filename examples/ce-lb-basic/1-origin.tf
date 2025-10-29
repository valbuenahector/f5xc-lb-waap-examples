//==========================================================================
// Definition of the Health Check
//==========================================================================
# resource "volterra_healthcheck" "http-health-check" {
#   name      = "http-health-check"
#   namespace = var.f5xc_namespace
#   http_health_check {
#     path            = "/"
#   }
#   healthy_threshold = 2
#   interval = 10
#   timeout = 1
#   unhealthy_threshold = 5
# }

//==========================================================================
// Definition of the Origin Pool
//==========================================================================
resource "volterra_origin_pool" "pool-tf-ce-juiceshop" {
  // The name of the origin pool
  name      = "pool-tf-ce-juiceshop"
  // The namespace where the origin pool will be created
  namespace = var.f5xc_namespace

  // The origin server configuration
  origin_servers {
    private_ip {
      ip = "10.84.102.251"
      site_locator {
        site {
          namespace = "system"
          name      = var.site_name
        }
      }
    }
    labels = {}
  }

  // The port used by the origin server
  port   = "80"
  no_tls = true

  // Attach the health check
  # healthcheck {
  #   name      = volterra_healthcheck.http-health-check.name
  #   namespace = volterra_healthcheck.http-health-check.namespace
  # }

  // The endpoint selection policy
  endpoint_selection     = "LOCALPREFERED"
  // The load balancing algorithm
  loadbalancer_algorithm = "LB_OVERRIDE"
}
