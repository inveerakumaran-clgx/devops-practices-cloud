project_id = "norse-decoder-375521"
region = "us-east1"
machine_type = "f1-micro"
zone = "us-east1-c"
# subnetwork = "default"
network_name = "main8"
public_subnet = "public8"
# num_instances = 1
service_account = ({
    email = "gcpproject@norse-decoder-375521.iam.gserviceaccount.com"
    scopes = ["cloud-platform"] 
})
image = "windows-server-2022-dc-v20230111"
image_family = "windows-2022"
image_project = "windows-cloud" 
subnets = [{
      subnet_name           = "public8"
      subnet_ip             = "10.0.1.0/24"
      subnet_region         = "us-east1"
      subnet_private_access = "false"
    },
    {
      subnet_name           = "private8"
      subnet_ip             = "10.0.2.0/24"
      subnet_region         = "us-east1"
      # purpose               = "INTERNAL_HTTPS_LOAD_BALANCER"
      role                  = "ACTIVE"
      subnet_private_access = "true"
}]
