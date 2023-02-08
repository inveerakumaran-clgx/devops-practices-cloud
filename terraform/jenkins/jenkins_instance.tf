
module "instance_template" {
  source                = "../.terraform/template/instance_template"
  region                = var.region
  project_id            = var.project_id
  subnetwork            = var.subnetwork
  machine_type          = var.machine_type
  service_account       = var.service_account
  source_image          = var.image
  source_image_family   = var.image_family
  source_image_project  = var.image_project
  tags                  = ["allow-ssh"]
}

module "compute_instance" {
  source              = "../.terraform/template/compute_instance"
  region              = var.region
  zone                = var.zone
  subnetwork          = var.subnetwork
  num_instances       = var.num_instances
  hostname            = "jenkins-simple"
  
  add_hostname_suffix = false
  instance_template   = module.instance_template.self_link
  access_config = [{
    nat_ip       = "${google_compute_address.default.address}"
    network_tier = var.network_tier
  }, ]
}

resource "google_compute_address" "default" {
  name     = var.nat_ip
  region   = var.region
}

module "firewall_rules" {
  source       = "../.terraform/template/firewall-rules"
  project_id   = var.project_id
  network_name = "default"

  rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["allow-ssh"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["8080"]
    },]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}

