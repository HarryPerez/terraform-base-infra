# S3 bucket for front with cloudfront
module "front-dev" {
  source = "../../aws/cloudfront_website"

  bucket_name           = "emic-front-dev" # Mandatory
  bucket_index_document = "index.html"     # Optional
  bucket_error_document = "index.html"     # Optional
  bucket_custom_domain  = ""               # Optional. For example 'mywebsite.emic.com.ar'

  # CloudFront variables
  cf_certificate_domain     = ""                  # Optional, e.g. "*.emic.com.ar"
  cf_enabled                = true                # Optional
  cf_aliases                = []                  # Optional, e.g. ["www.emic.com.ar", "web.emic.com.ar"]
  cf_allowed_methods        = ["GET", "HEAD"]     # Optional
  cf_cached_methods         = ["GET", "HEAD"]     # Optional
  cf_forward_query_string   = true                # Optional
  cf_forward_cookies        = "none"              # Optional, one of "all" or "none"
  cf_viewer_protocol_policy = "redirect-to-https" # Optional, one of "allow-all", "https-only" or "redirect-to-https"
  cf_min_ttl                = 0                   # Optional
  cf_default_ttl            = 0                   # Optional
  cf_max_ttl                = 0                   # Optional
  cf_compress               = true                # Optional
}

# EB/EC2 for backend with Node
data "aws_elastic_beanstalk_solution_stack" "docker_latest" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running Docker (.*)$"
}

# Create the VPC and subnets
module "vpc" {
  source              = "../../aws/vpc"
  application         = "emic-backend"
  environment         = "dev-back"
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnets      = "${var.public_subnets}"
  dbs_private_subnets = "${var.dbs_private_subnets}"
  ssh_cidr            = "0.0.0.0/0"                  # Mandatory. Please, don't use this default.
}

# Create the beanstalk app
resource "aws_elastic_beanstalk_application" "app" {
  name = "emic-backend"
}

#EC2
resource "aws_instance" "emic-dev" {
  ami           = "ami-07bfe0a3ec9dfcffa" # ami for Ubuntu - Amazon Machine Image
  instance_type = "t3.micro"              #Instance type

  # Manually set a VPC
  vpc_security_group_ids = ["${module.vpc.servers_sg_id}"]
  subnet_id              = "subnet-069de262906c8369a"
}

# Create the beanstalk environment
module "server" {
  source              = "../../aws/eb/environment"
  application         = "emic-backend"
  environment         = "dev-back"
  vpc_id              = "${module.vpc.vpc_id}"
  subnets             = "${module.vpc.public_subnets}"
  security_group      = "${module.vpc.servers_sg_id}"
  ec2_key_name        = "emic"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
  environment_type    = "SingleInstance"
  instance_type       = "t3.micro"
  rds_connection_url  = ""
}
