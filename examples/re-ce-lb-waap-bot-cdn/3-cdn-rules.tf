//==========================================================================
//Definition of the CDN Cache Rules
//==========================================================================
resource "volterra_cdn_cache_rule" "cdn-rules-app1-tf-1" {
  name      = "cdn-rules-app1-tf-1"
  namespace = var.f5xc_namespace

  // Rule 1: Cache CSS and JS files for 1 day
  cache_rules {
    rule_name = "cache-css-js"
    rule_expression_list {
        expression_name = "cache-css-js-exp"
        cache_rule_expression { 
            path_match {
                operator {
                    match_regex = "\\\\/[\\\\w\\\\-\\\\/]+\\\\/[\\\\w\\\\-]+\\\\.(css|js)(?=\\\\?)"
                }
            }
        }
    }
    eligible_for_cache {
        scheme_proxy_host_uri {
            cache_ttl = "86400s"
        }
    }
  }
}

resource "volterra_cdn_cache_rule" "cdn-rules-app1-tf-2" {
  name      = "cdn-rules-app1-tf-2"
  namespace = var.f5xc_namespace
  // Rule 2: Cache image files for 7 days
  cache_rules {
    rule_name = "cache-images"
    rule_expression_list {
        expression_name = "cache-images-exp"
        cache_rule_expression {
            path_match {
                operator {
                    match_regex = "\\\\/[\\\\w\\\\-\\\\/]+\\\\/[\\\\w\\\\-]+\\\\.(jpg|jpeg|png|gif|webp|svg)(?=\\\\?)"
                }
            }
        }
    }
    eligible_for_cache {
        scheme_proxy_host_uri {
            cache_ttl = "604800s"
        }
    }
  }
}

resource "volterra_cdn_cache_rule" "cdn-rules-app1-tf-3a" {
  name      = "cdn-rules-app1-tf-3a"
  namespace = var.f5xc_namespace

  // Rule 3a: Do not cache ACS paths
  cache_rules {
    rule_name = "no-cache-acs"
    rule_expression_list {
        expression_name = "no-cache-acs-exp"
        cache_rule_expression {
            path_match {
                operator {
                    startswith = "/acs/"
                }
            }
        }
    }
    cache_bypass = true
  }

}

resource "volterra_cdn_cache_rule" "cdn-rules-app1-tf-3b" {
  name      = "cdn-rules-app1-tf-3b"
  namespace = var.f5xc_namespace

  // Rule 3b: Do not cache API paths
  cache_rules {
    rule_name = "no-cache-api"
    rule_expression_list {
        expression_name = "no-cache-api-exp"
        cache_rule_expression {
            path_match {
                operator {
                    startswith = "/api/"
                }
            }
        }
    }
    cache_bypass = true
  }

}