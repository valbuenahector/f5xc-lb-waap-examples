//==========================================================================
//Definition of the WAAP Policy
//==========================================================================
resource "volterra_app_firewall" "waap-tf" {
  name      = "waap-policy-tf-ce"
  namespace = var.f5xc_namespace

  // Allow all response codes
  allow_all_response_codes = true
  // Use default anonymization for sensitive data
  default_anonymization = true
  // Use the default blocking page
  use_default_blocking_page = true
  // Use the default detection settings
  default_detection_settings = true
  // Set the enforcement mode to blocking
  blocking = true
}
