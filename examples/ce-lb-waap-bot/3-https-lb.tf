//==========================================================================
//Definition of the HTTP Load Balancer
//==========================================================================
resource "volterra_http_loadbalancer" "lb-app1-tf" {
    depends_on = [volterra_origin_pool.pool-tf-juiceshop, volterra_app_firewall.waap-tf]
    // The name of the load balancer
    name      = "tf-ce-juiceshop-waap"
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
        name = volterra_origin_pool.pool-tf-juiceshop.name
        namespace = var.f5xc_namespace
        }
        weight = 1
    }
    
    advertise_custom {
        advertise_where {
            site {
                network = "SITE_NETWORK_INSIDE_AND_OUTSIDE"
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
    
    // Apply the WAAP policy
    app_firewall {
        name = volterra_app_firewall.waap-tf.name
        namespace = var.f5xc_namespace
    }
    user_id_client_ip = true
    
    // Enable source IP stickiness
    source_ip_stickiness = true
}
