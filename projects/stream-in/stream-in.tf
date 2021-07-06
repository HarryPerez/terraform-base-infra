# EB/EC2 for backend with RoR Multi container
data "aws_elastic_beanstalk_solution_stack" "docker_latest" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running Multi-container Docker (.*)$"
}

# Create the VPC and subnets
module "vpc" {
  source              = "../../aws/vpc"
  application         = "stream-in-backend"
  environment         = "dev-back"
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnets      = "${var.public_subnets}"
  dbs_private_subnets = "${var.dbs_private_subnets}"
  ssh_cidr            = "0.0.0.0/0"                  # Mandatory. Please, don't use this default.
}

# Create the beanstalk app
resource "aws_elastic_beanstalk_application" "app" {
  name = "stream-in-backend"
}

#EC2 - NOTE: Remember to create EC2 Key Pair Name
resource "aws_instance" "stream-in-dev" {
  ami           = "ami-07bfe0a3ec9dfcffa" # ami for Ubuntu - Amazon Machine Image
  instance_type = "t3.small"              #Instance type

  # Manually set a VPC
  vpc_security_group_ids = ["${module.vpc.servers_sg_id}"]
  subnet_id              = "subnet-06c38f5a2d8f47b1a"
}

# EB/EC2 for backend
module "dev-back" {
  source = "../../aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0" # Mandatory. Please, don't use this default.

  rds_db_name        = "development" # Mandatory
  rds_username       = "postgres"    # Mandatory
  rds_password       = "postgres"    # Mandatory
  rds_engine         = "postgres"    # Optional
  rds_engine_version = "11.8"        # Optional
  rds_port           = "5432"        # Optional
  rds_multi_az       = false         # Optional
  rds_instance_type  = "db.t3.micro" # Optional

  eb_application         = "stream-in-backend"                                               # Mandatory
  eb_environment         = "dev-back"                                                        # Mandatory
  eb_ec2_key_name        = "streamin-rails"                                                  # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance"                                                  # Optional
  eb_instance_type       = "t3.small"                                                        # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
}
