terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # sets configs for AWS provider. Terraform things.
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Test
/*
module "bucket" {
  source = "./aws/s3/website"

  bucket_name          = "zerf-bucket" # Mandatory
  index_document       = "index.html"  # Optional
  error_document       = "index.html"  # Optional
  bucket_custom_domain = ""            # Optional. For example 'mywebsite.zerf.com.ar'
}
*/