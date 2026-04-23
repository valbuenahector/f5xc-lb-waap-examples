resource "volterra_app_firewall" "main" {
  name      = "ce-waap-policy"
  namespace = var.f5xc_namespace

  allow_all_response_codes  = true
  default_anonymization     = true
  use_default_blocking_page = true
  // Use the default detection settings (includes default violation,
  // signature, and threat campaign settings)
  default_detection_settings = true
  blocking = true
}
