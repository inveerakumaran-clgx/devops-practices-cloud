resource "google_compute_address" "database" {
  name = "database"
  region = "us-east1"
}

module "instance_template" {
  source  = "../.terraform/template/instance_template"
  region                = var.region
  project_id            = var.project_id
  subnetwork            = var.private_subnet
  service_account       = var.service_account
  source_image          = var.image
  source_image_family   = var.image_family
  source_image_project  = var.image_project
  startup_script        =  file("startscript.sh")
  access_config = [{
    nat_ip  = "${google_compute_address.database.address}"
    network_tier = var.network_tier
  }]

}

module "mig" {
  source  = "../.terraform/template/mig"
  instance_template = module.instance_template.self_link
  region = var.region
  hostname = "dbvm1"
  project_id = var.project_id
  min_replicas = "1"
  max_replicas = "1"

  named_ports = [{
    name = "http"
    port = "3389"
  },{
    name = "http"
    port = "80"    
  },{
    name = "http"
    port = "22"    
  },{
    name = "http"
    port = "443"    
  }]

}

module "firewall_rules" {
  source       = "../.terraform/template/firewall-rules"
  project_id   = var.project_id
  network_name = "main8"

  rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}

# module "dynamic_backends" {
#   source  = "../.terraform/template/dynamic_backends"
#   # insert the 3 required variables here

#  project           = var.project_id
#   name              = "group-http-lb8"
#   # target_tags       = [module.mig1.target_tags, module.mig2.target_tags]
#   backends = {
#     dbvm1 = {
#       port                            = 80
#       protocol                        = "HTTP"
#       port_name                       = "http"
#       description                     = null            
#       enable_cdn                      = false
#       security_policy                 = null
#       custom_request_headers          = null
#       custom_response_headers         = null

#       timeout_sec                     = 10
#       connection_draining_timeout_sec = null
#       session_affinity                = null
#       affinity_cookie_ttl_sec         = null

#       health_check = {
#         check_interval_sec  = 30
#         timeout_sec         = 10
#         healthy_threshold   = 1
#         unhealthy_threshold = 5
#         request_path        = "/"
#         port                = 80
#         host                = null
#         logging             = null
#       }

#       log_config = {
#         enable = false
#         sample_rate = null
#       }

#       groups = [
#         {
#           # Each node pool instance group should be added to the backend.
#           group                        = module.mig.instance_group
#           balancing_mode               = null
#           capacity_scaler              = null
#           description                  = null
#           max_connections              = null
#           max_connections_per_instance = null
#           max_connections_per_endpoint = null
#           max_rate                     = null
#           max_rate_per_instance        = null
#           max_rate_per_endpoint        = null
#           max_utilization              = null
#         },
#       ]

#       iap_config = {
#         enable               = false
#         oauth2_client_id     = null
#         oauth2_client_secret = null
#       }
#     }
#   }
# }

# resource "google_compute_url_map" "group-http-lb8-url-map" {
#   name            = "group-http-lb8-url-map"
#   default_service = google_compute_backend_service.default.id
# }

# # backend service
# resource "google_compute_backend_service" "default" {
#   name                    = "backend"
#   protocol                = "HTTP"
#   port_name               = "http"
#   load_balancing_scheme   = "EXTERNAL" 
#   enable_cdn              = "true"
#   health_checks           = [google_compute_http_health_check.default.id]
#   backend {
#     # group           = google_compute_instance_group_manager.default.instance_group
#     group             = module.mig.instance_group
#   }
# }

# resource "google_compute_http_health_check" "default" {
#   name               = "health-check"
#   request_path       = "/"
#   check_interval_sec = 1
#   timeout_sec        = 1
# }