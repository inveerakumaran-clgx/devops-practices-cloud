terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0"
    }
  }
}


# Configure AWS provider:


provider "aws" {
  region  = "us-east-1"
  access_key = "AKIAWLKZN47RSRFWFPWJ"
  secret_key =  "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"
}
