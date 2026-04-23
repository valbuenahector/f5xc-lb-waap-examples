//==========================================================================
//Definition of the HTTP Load Balancer
//==========================================================================
resource "volterra_http_loadbalancer" "lb-app1-tf" {
    depends_on = [volterra_origin_pool.pool-tf-juiceshop, volterra_app_firewall.waap-tf]
    // The name of the load balancer
    name      = "lb-app1-tf-waap-cdn"
    // The namespace where the load balancer will be created
    namespace = var.f5xc_namespace

    // The domains that will be served by this load balancer
    domains = [var.app_domain]
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
    user_id_client_ip = true

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

    // CDN Caching - enabled directly on the HTTP LB (April 2026+)
    // Replaces the previous approach of using a separate CDN LB,
    // CDN origin pool, service policy, and CDN routing workaround.
    // Note: source_ip_stickiness is incompatible with CDN caching.
    caching_policy {
        // Default cache action: respect origin Cache-Control headers,
        // fall back to 1 hour TTL if origin doesn't provide one
        default_cache_action {
            cache_ttl_default = "3600s"
        }
        // Custom cache rules for fine-grained control
        custom_cache_rule {
            cdn_cache_rules {
                name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-1.name
                namespace = var.f5xc_namespace
            }
            cdn_cache_rules {
                name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-2.name
                namespace = var.f5xc_namespace
            }
            cdn_cache_rules {
                name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-3a.name
                namespace = var.f5xc_namespace
            }
            cdn_cache_rules {
                name      = volterra_cdn_cache_rule.cdn-rules-app1-tf-3b.name
                namespace = var.f5xc_namespace
            }
        }
    }

    // Routes
    routes {
        direct_response_route {
            path {
                prefix = "/healthcheck"
            }
            http_method = "GET"
            route_direct_response {
                response_code = 200
                response_body = "HealthCheck OK"
            }
        }
    }
}
