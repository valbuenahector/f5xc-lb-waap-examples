resource "volterra_app_firewall" "main" {
  name      = "ce-waap-policy"
  namespace = var.f5xc_namespace

  allow_all_response_codes = true
  default_anonymization    = true
  use_default_blocking_page = true

  blocking = true
  detection_settings {
    default_violation_settings = true
    enable_threat_campaigns = true
    signature_selection_setting {
      default_attack_type_settings = true
      high_medium_accuracy_signatures = true
    }
  }
}
