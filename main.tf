terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Bucket S3
resource "aws_s3_bucket" "novimo" {
  bucket = "zerf-s3-terraform-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name = "my-test-s3-tags-bucket"
  }
}

# EC2
resource "aws_instance" "rocky" {
  ami           = "ami-0739f8cdb239fe9ae"
  instance_type = "t2.nano"
}

# Test - EB && RDS
/*
data "aws_elastic_beanstalk_solution_stack" "docker_latest" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) running Docker (.*)$"
}

module "back-dev" {
  source = "./aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0" # Mandatory. Please, don't use this default.

  rds_db_name        = "development"             # Mandatory
  rds_username       = "zerfuser"                # Mandatory
  rds_password       = "${var.rds_password_dev}" # Mandatory
  rds_engine         = "postgres"                # Optional
  rds_engine_version = "11.5"                    # Optional
  rds_port           = "5432"                    # Optional
  rds_multi_az       = false                     # Optional
  rds_instance_type  = "db.t3.micro"             # Optional

  eb_application         = "zerf-backend"                                                    # Mandatory
  eb_environment         = "dev-back"                                                        # Mandatory
  eb_ec2_key_name        = "zerf-dev"                                                        # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance"                                                  # Optional
  eb_instance_type       = "t3.micro"                                                        # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
}
*/

