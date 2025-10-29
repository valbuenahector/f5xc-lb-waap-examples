//==========================================================================
//Definition of the HTTPS Load Balancer
//==========================================================================
resource "volterra_http_loadbalancer" "lb-app1-tf-ce" {
    depends_on = [volterra_origin_pool.pool-tf-ce-juiceshop]
    // The name of the load balancer
    name      = "lb-app1-tf-ce"
    // The namespace where the load balancer will be created
    namespace = var.f5xc_namespace
    
    // The domains that will be served by this load balancer
    domains = [var.app_domain]
    
    // HTTPS configuration with custom certificate
    https {
        port = 443
        add_hsts = true
        http_redirect = true
        tls_cert_params {
            certificates {
                name = "ceonly-hvf5lab-com"
                namespace = var.f5xc_namespace
            }
            no_mtls = true
            tls_config {
                default_security = true
            }
        }
    }

    // The default origin pool for this load balancer
    default_route_pools {
        pool {
            name = volterra_origin_pool.pool-tf-ce-juiceshop.name
            namespace = volterra_origin_pool.pool-tf-ce-juiceshop.namespace
        }
        weight = 1
    }
    
    // Advertise the VIP on the site network
    advertise_custom {
        advertise_where {
            port = 443
            site {
                network = "SITE_OUTSITE_NETWORK"
                site {
                    namespace = "system"
                    name = var.site_name
                }
            }
        }
    }
    
    // Security configuration
    no_service_policies = true
    no_challenge = true
    disable_rate_limit = true
    disable_waf = true
    user_id_client_ip = true
    
    // Enable source IP stickiness
    source_ip_stickiness = true
}
