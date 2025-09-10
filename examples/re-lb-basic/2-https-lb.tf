//==========================================================================
//Definition of the HTTP Load Balancer
//==========================================================================
resource "volterra_http_loadbalancer" "lb-app1-tf" {
    depends_on = [volterra_origin_pool.pool-tf-juiceshop]
    // The name of the load balancer
    name      = "lb-app1-tf"
    // The namespace where the load balancer will be created
    namespace = var.f5xc_namespace
    
    // The domains that will be served by this load balancer
    domains = ["apptf1.wwt.xcsdemo.com"]
    // HTTPS configuration with automatic certificate management
    https_auto_cert {
        add_hsts = true
        http_redirect = true
        no_mtls = true
        enable_path_normalize = true
        tls_config {
            default_security = true
        }
    }
    // The default origin pool for this load balancer
    default_route_pools {
        pool {
        name = "pool-tf-juiceshop"
        namespace = var.f5xc_namespace
        }
        weight = 1
    }
    // Advertise the VIP on the public default network
    advertise_on_public_default_vip = true
    
    // Security configuration
    no_service_policies = true
    no_challenge = true
    disable_rate_limit = true
    disable_waf = true
    user_id_client_ip = true
    
    // Enable source IP stickiness
    source_ip_stickiness = true
}
