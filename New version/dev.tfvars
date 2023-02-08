machine_type = "f1-micro"
service_account = ({
    email = "packerimage@norse-decoder-375521.iam.gserviceaccount.com"
    scopes = ["cloud-platform"] 
})
project_id = "norse-decoder-375521"
network_name = "main"
public_subnet = "public"
private_subnet = "private"
region = "us-east1"
zone = "us-east1-c"
image = "windows-server-2022-dc-v20230111"
image_family = "windows-2022"
image_project = "windows-cloud" 
backends = {
    default = {
      port                            = 80
      protocol                        = "HTTP"
      port_name                       = "http"
      description                     = null            
      enable_cdn                      = false
      security_policy                 = null
      custom_request_headers          = null
      custom_response_headers         = null

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
