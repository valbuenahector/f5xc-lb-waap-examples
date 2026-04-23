//==========================================================================
//Definition of the Origin Pool
//==========================================================================
resource "volterra_origin_pool" "pool-tf-juiceshop" {
    // The name of the origin pool
    name                   = "pool-tf-juiceshop-cdn"
    // The namespace where the origin pool will be created
    namespace              = var.f5xc_namespace
 
    // The origin server configuration
    origin_servers {
        public_name {
            dns_name = var.origin_dns_name
        }
        labels = {}
    }

    // No TLS - origin is plain HTTP on port 80
    no_tls = true
    // The port used by the origin server
    port = "80"
    // The endpoint selection policy
    endpoint_selection     = "LOCALPREFERED"
    // The load balancing algorithm
    loadbalancer_algorithm = "LB_OVERRIDE"
}
