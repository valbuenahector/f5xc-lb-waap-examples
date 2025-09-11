//==========================================================================
//Definition of the HTTP Load Balancer
//==========================================================================
resource "volterra_http_loadbalancer" "lb-app1-tf" {
    depends_on = [volterra_origin_pool.pool-tf-juiceshop, volterra_app_firewall.waap-tf]
    // The name of the load balancer
    name      = "lb-app1-tf-waap"
    // The namespace where the load balancer will be created
    namespace = var.f5xc_namespace
    
    // The domains that will be served by this load balancer
    domains = ["apptf1-waap.wwt.xcsdemo.com"]
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
        name = volterra_origin_pool.pool-tf-juiceshop.name
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
    
    // Apply the WAAP policy
    app_firewall {
        name = volterra_app_firewall.waap-tf.name
        namespace = var.f5xc_namespace
    }
    # Argument is deprecated
    # multi_lb_app = true
    user_id_client_ip = true
    
    // Enable source IP stickiness
    source_ip_stickiness = true
    
    // Bot Defense configuration
    bot_defense {
        policy {
            javascript_mode = "ASYNC_JS_NO_CACHING"
            js_insert_all_pages {
                javascript_location = "AFTER_HEAD"
            }
            protected_app_endpoints {
                http_methods = ["METHOD_POST"]
                flow_label {
                    authentication {
                        login_mfa = true
                    }
                }
                metadata {
                    name = "login-endpoint"
                }
                mitigation {
                    block {
                        status = "PaymentRequired"
                    }
                }
                path {
                    path = "/rest/user/login"
                }
            }
        }
        regional_endpoint = "US"
    }
}
