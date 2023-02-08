project_id = "norse-decoder-375521"
region = "us-east1"
zone = "us-east1-c"
subnetwork = "default"
machine_type = "e2-medium"
num_instances = 1
service_account = ({
    email = "gcpproject@norse-decoder-375521.iam.gserviceaccount.com"
    scopes = ["cloud-platform"] 
})
image = "windows-server-2022-dc-v20230111"
image_family = "windows-2022"
image_project = "windows-cloud" 
nat_ip = "jenkins"