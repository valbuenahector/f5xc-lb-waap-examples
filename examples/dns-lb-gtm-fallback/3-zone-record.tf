# Binds the DNS Load Balancer into an existing DNS Zone's rrset via a
# volterra_dns_zone_record lb_record. Left commented out: creating/managing
# the DNS Zone itself is out of scope for this example, and the provider
# docs indicate the zone's record-group ordering is typically managed
# through the F5XC console alongside other rrsets in the same zone — mixing
# Terraform-managed and console-managed records in one zone risks drift.
# Uncomment and adapt once the target zone/group is confirmed.
#
# resource "volterra_dns_zone_record" "example" {
#   dns_zone_name = var.dns_zone_name
#   namespace     = var.f5xc_namespace
#   group_name    = "default"
#
#   rrset {
#     ttl = 300
#
#     lb_record {
#       host = "example.com"
#
#       dns_lb_pool {
#         name      = volterra_dns_load_balancer.example.name
#         namespace = var.f5xc_namespace
#       }
#     }
#   }
# }
