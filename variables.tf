# Create the beanstalk app

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "rds_password_dev" {}
variable "rds_password_stage" {}
variable "vpc_stage_id" {}
variable "vpc_sgroup_stage_id" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
