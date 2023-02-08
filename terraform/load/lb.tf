resource "google_compute_address" "windows1" {
  name = "windows1"
  region = "us-east1"
  # network = "main8"
  # subnetwork = "public8"
}

resource "google_compute_address" "windows2" {
  name = "windows2"
  region = "us-east1"
  # network = "main8"
  # subnetwork = "public8"
}

module "vpc" {
  source                                 = "../.terraform/template/vpc"
  network_name                           = var.network_name
  auto_create_subnetworks                = var.auto_create_subnetworks
  routing_mode                           = var.routing_mode
  project_id                             = var.project_id
  description                            = var.description
  shared_vpc_host                        = var.shared_vpc_host
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  mtu                                    = var.mtu
}

module "subnets" {
  source                                 = "../.terraform/template/subnets"
  project_id                             = var.project_id
  network_name                           = module.vpc.network_name
  subnets                                = var.subnets
  secondary_ranges                       = var.secondary_ranges
}

module "instance_template" {
  source  = "../.terraform/template/instance_template"
  machine_type = var.machine_type
  network = var.network_name
  project_id = var.project_id
  region = var.region
  # name_prefix = "windows"
  source_image = var.image
  source_image_family = var.image_family
  source_image_project = var.image_project
  subnetwork = var.public_subnet
  service_account = var.service_account
  access_config = [{
    nat_ip  = "${google_compute_address.windows1.address}"
    network_tier = var.network_tier
  }
  
  ]

}

module "mig" {
  source  = "../.terraform/template/mig"
  instance_template = module.instance_template.self_link
  region = var.region
  project_id = var.project_id
  hostname = "windows"
  autoscaling_enabled = "true"
  autoscaler_name = "test"
  autoscaling_lb = []
  min_replicas = "1"
  max_replicas = "2"

  # health_check = {
  #   type                = "http"
  #   initial_delay_sec   = 30
  #   check_interval_sec  = 30
  #   healthy_threshold   = 1
  #   timeout_sec         = 10
  #   unhealthy_threshold = 5
  #   response            = ""
  #   proxy_header        = "NONE"
  #   port                = 80
  #   request             = ""
  #   request_path        = "/"
  #   host                = ""
  #   enable_logging      = false
  # }

  named_ports = [{
    name = "http"
    port = "3389"
  },{
    name = "http"
    port = "80"    
  }]
}

module "dynamic_backends" {
  source  = "../.terraform/template/dynamic_backends"
  # insert the 3 required variables here

 project           = var.project_id
  name              = "group-http-lb8"
  # target_tags       = [module.mig1.target_tags, module.mig2.target_tags]
  

  backends = {
    dbvm = {
      port                            = 80
      protocol                        = "HTTP"
      port_name                       = "http"
      description                     = null            
      enable_cdn                      = false
      security_policy                 = null
      custom_request_headers          = null
      custom_response_headers         = null
      compression_mode = "DISABLED"

      timeout_sec                     = 10
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
        enable = false
        sample_rate = null
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = module.mig.instance_group
          balancing_mode               = null
          capacity_scaler              = 0.8
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
    # dbvm1 = {
    #   port                            = 80
    #   protocol                        = "HTTP"
    #   port_name                       = "http"
    #   description                     = null            
    #   enable_cdn                      = false
    #   security_policy                 = null
    #   custom_request_headers          = null
    #   custom_response_headers         = null
    #   # compression_mode = "DISABLED" 

    #   timeout_sec                     = 10
    #   connection_draining_timeout_sec = null
    #   session_affinity                = null
    #   affinity_cookie_ttl_sec         = null

    #   health_check = {
    #     check_interval_sec  = 30
    #     timeout_sec         = 10
    #     healthy_threshold   = 1
    #     unhealthy_threshold = 5
    #     request_path        = "/"
    #     port                = 80
    #     host                = null
    #     logging             = null
    #   }

    #   log_config = {
    #     enable = false
    #     sample_rate = null
    #   }

    #   groups = [
    #     {
    #       # Each node pool instance group should be added to the backend.
    #       group                        = "${dbvm1-mig}"
    #       balancing_mode               = null
    #       capacity_scaler              = null
    #       description                  = null
    #       max_connections              = null
    #       max_connections_per_instance = null
    #       max_connections_per_endpoint = null
    #       max_rate                     = null
    #       max_rate_per_instance        = null
    #       max_rate_per_endpoint        = null
    #       max_utilization              = null
    #     },
    #   ]

    #   iap_config = {
    #     enable               = false
    #     oauth2_client_id     = null
    #     oauth2_client_secret = null
    #   }
    # }
  }
}



