//==========================================================================
//Definition of the Origin Pool
//==========================================================================
resource "volterra_origin_pool" "pool-tf-juiceshop" {
    // The name of the origin pool
    name                   = "pool-tf-juiceshop-waap"
    // The namespace where the origin pool will be created
    namespace              = var.f5xc_namespace
 
    // The origin server configuration
    origin_servers {
        public_name {
            dns_name = "juiceshop.hvf5lab.com"
        }
        labels = {}
    }

    // TLS configuration for the origin server
    use_tls {
    use_host_header_as_sni = true
    tls_config {
        default_security = true
    }
    skip_server_verification = true
    no_mtls = true
    }

    no_tls = true
    // The port used by the origin server
    port = "80"
    // The endpoint selection policy
    endpoint_selection     = "LOCALPREFERED"
    // The load balancing algorithm
    loadbalancer_algorithm = "LB_OVERRIDE"
}
