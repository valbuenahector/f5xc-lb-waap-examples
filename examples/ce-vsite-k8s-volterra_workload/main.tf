resource "volterra_workload" "example" {
  name      = var.workload_name
  namespace = var.f5xc_namespace

  service {
    num_replicas = 1
    containers {
      name = var.workload_name
      image {
        name = var.container_image
        container_registry {
          name      = var.container_registry_name
          namespace = var.f5xc_namespace
          tenant    = var.f5xc_tenant
        }
        pull_policy = "IMAGE_PULL_POLICY_DEFAULT"
      }
      init_container = false
      flavor         = "CONTAINER_FLAVOR_TYPE_TINY"
    }

    # As requested: site_name = "hv-aws-us-east-1-ce"
    # The JSON example showed virtual_site, but your parameters mentioned site_name.
    # We'll use deploy_site which is commonly used with site_name.
    deploy_options {
      deploy_site {
        site {
          name      = var.site_name
          namespace = "system"
          tenant    = var.f5xc_tenant
        }
      }
    }

    advertise_options {
      advertise_in_cluster {
        port {
          info {
            port         = var.container_port
            protocol     = "PROTOCOL_TCP"
            same_as_port = true
          }
        }
      }
    }

    family {
      v4 = true
    }
  }
}
