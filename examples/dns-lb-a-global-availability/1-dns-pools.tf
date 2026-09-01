# Primary A pool — priority-ordered members, modeling a GTM "a" pool in
# global-availability mode (first available member answers, in priority
# order). Schema-verified against a_pool (schemas/0.11.49/volterra_dns_lb_pool.json):
# max_answers is required; members.priority/ratio/disable are optional;
# disable_health_check and an optional health_check block are also available
# (unlike aaaa_pool, which has neither — see dns-lb-gtm-fallback for that gap).
resource "volterra_dns_lb_pool" "primary" {
  name      = "a-tf-primary-pool"
  namespace = var.f5xc_namespace

  a_pool {
    max_answers = 1

    members {
      priority    = 1
      ip_endpoint = var.primary_member_1_ipv4
    }

    members {
      priority    = 2
      ip_endpoint = var.primary_member_2_ipv4
    }
  }
}

# Fallback pool — sole member is the GTM pool's fallback-ip equivalent.
# Referenced by the DNS Load Balancer's fallback_pool block in 2-dns-lb.tf.
# Needs Verification (see dns-lb-gtm-fallback/docs): fallback_pool is
# confirmed to activate when no rule matches the query; whether it also
# activates when the matched pool's members are all unhealthy is not
# confirmed in F5XC docs reviewed so far.
resource "volterra_dns_lb_pool" "fallback" {
  name      = "a-tf-fallback-pool"
  namespace = var.f5xc_namespace

  a_pool {
    max_answers = 1

    members {
      priority    = 1
      ip_endpoint = var.fallback_ipv4
    }
  }
}
