module "vpc" {
   source  = "terraform-google-modules/network/google"
  version = "6.0.1"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "REGIONAL"

  delete_default_internet_gateway_routes = "true"

  subnets = [
     {
      subnet_name           = var.private_subnet
      subnet_ip             = "10.0.2.0/24"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    },
    {
      subnet_name           = var.public_subnet
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = var.region
      subnet_private_access = "false"
      subnet_flow_logs      = "false"
    }
  ]
}

# https://github.com/terraform-google-modules/terraform-google-cloud-router
module "cloud_router" {
   source  = "terraform-google-modules/cloud-router/google"
  version = "4.0.0"

  name    = "router1"
  project = var.project_id
  region  = var.region
  network = module.vpc.network_name
  nats = [{
    name                               = "nats"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [{
      name                    = var.private_subnet
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }]
  }]
}

module "vm_instance_template2" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "8.0.0"
  machine_type = var.machine_type
  network = var.network_name
  project_id = var.project_id
  region = var.region
  source_image = var.image
  source_image_family = var.image_family
  source_image_project = var.image_project
  subnetwork = var.public_subnet
  service_account = var.service_account
}

module "vm_mig3" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "8.0.0"
  instance_template = module.vm_instance_template2.self_link
  region = var.region
  project_id = var.project_id

  health_check = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
    enable_logging      = false
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "6.3.0"
  # insert the 3 required variables here

 project           = var.project_id
  name              = "group-http-lb3"
  # target_tags       = [module.mig1.target_tags, module.mig2.target_tags]
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 10
      enable_cdn                      = false
      custom_request_headers          = null
      custom_response_headers         = null
      security_policy                 = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = 30
        timeout_sec         = 10
        healthy_threshold   = 1
        unhealthy_threshold = 5
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = module.vm_mig3.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }

}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "8.0.0"
  region          = var.region
  project_id      = var.project_id
  subnetwork      = var.private_subnet
  service_account = var.service_account
  startup_script    = <<EOF
#!/bin/bash
sudo su
yum -y update
yum install mysql -y
EOF
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "8.0.0"
  region              = var.region
  zone                = var.zone
  subnetwork          = var.private_subnet
  num_instances       = "1"
  hostname            = "dbvm"
  instance_template   = module.instance_template.self_link
  deletion_protection = false

  # access_config = [{
  #   nat_ip       = var.nat_ip
  #   network_tier = var.network_tier
  # }, ]
}