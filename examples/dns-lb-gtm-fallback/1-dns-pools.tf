# Primary AAAA pool — priority-ordered members, modeling the GTM AAAA pool's
# primary member set (global-availability / priority load-balancing mode).
resource "volterra_dns_lb_pool" "primary" {
  name      = "aaaa-tf-primary-pool"
  namespace = var.f5xc_namespace

  aaaa_pool {
    max_answers = 1

    members {
      priority    = 1
      ip_endpoint = var.primary_member_1_ipv6
    }

    members {
      priority    = 2
      ip_endpoint = var.primary_member_2_ipv6
    }
  }

  # NOTE (Needs Verification): the aaaa_pool block does not expose a
  # health_check / disable_health_check argument in the pinned provider
  # schemas (0.11.39-0.11.49) — unlike a_pool, which has both. Confirm with
  # F5 whether AAAA member health is evaluated by another mechanism before
  # relying on priority failover here.
}

# Fallback pool — sole member is the GTM pool's fallback-ip equivalent.
# Referenced by the DNS Load Balancer's fallback_pool block in 2-dns-lb.tf.
resource "volterra_dns_lb_pool" "fallback" {
  name      = "aaaa-tf-fallback-pool"
  namespace = var.f5xc_namespace

  aaaa_pool {
    max_answers = 1

    members {
      priority    = 1
      ip_endpoint = var.fallback_ipv6
    }
  }
}
