provider "aws" {
  # You can specify an access_key and a secret_key instead of an AWS profile
  # access_key = "XXXXXXXXXX"
  # secret_key = "XXXXXXXXXX"
  profile = "eb-cli"
  region  = "eu-east-1"
}

# Create the bucket with website configuration
module "bucket" {
  source = "git@github.com:HarryPerez/terraform-base-infra.git//aws/s3/website"

  bucket_name          = "zerf-bucket" # Mandatory
  index_document       = "index.html"  # Optional
  error_document       = "index.html"  # Optional
  bucket_custom_domain = ""            # Optional. For example 'mywebsite.zerf.com.ar'
}