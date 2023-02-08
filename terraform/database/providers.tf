terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.49.0"
       
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.48.0"
    }
  }
}

provider "google" {
  # Configuration options
    credentials = file("norse.json")
 project = var.project_id
  region  = var.region
  zone    = var.zone
}


provider "google-beta" {
  # Configuration options
    credentials = file("norse.json")
}