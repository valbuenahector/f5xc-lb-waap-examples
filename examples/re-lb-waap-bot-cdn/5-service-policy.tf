resource "volterra_service_policy" "cdn-sp" {
  name      = "cdn-${split(".", var.app_domain)[0]}-sp"
  namespace = var.f5xc_namespace
  algo      = "FIRST_MATCH"

  rule_list {
    rules {
      metadata {
        name = "cdn-${split(".", var.app_domain)[0]}-sp-header-check"
      }
      spec {  
        action = "ALLOW"
        headers {
          name = "secure-to-cdn"
          item {
            exact_values = ["true"]
          }
        }
        waf_action {
          none = true
        }
      }
    }
    rules {
      metadata {
        name = "cdn-${split(".", var.app_domain)[0]}-sp-deny"
      }
      spec {
        action = "DENY"
        waf_action {
          none = true
        }
      }
    }
  }
}
