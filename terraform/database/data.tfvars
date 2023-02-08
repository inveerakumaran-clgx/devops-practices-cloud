project_id = "norse-decoder-375521"
region = "us-east1"
zone = "us-east1-c"
subnetwork = "default"
num_instances = 1
service_account = ({
    email = "gcpproject@norse-decoder-375521.iam.gserviceaccount.com"
    scopes = ["cloud-platform"] 
})
image = "ubuntu-minimal-2204-jammy-v20230112a"
image_family = "ubuntu-minimal-2204-lts"
image_project = "ubuntu-os-cloud"