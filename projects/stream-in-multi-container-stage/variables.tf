# Create the beanstalk app

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# VPC Variables
variable "public_subnets" {
  type = "list"

  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "dbs_private_subnets" {
  type = "list"

  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}
