# EB/EC2 for backend
module "back-stage" {
  source = "../aws/eb_rds"

  aws_region = "us-east-1"                  # Mandatory
  aws_azs    = ["us-east-1a", "us-east-1b"] # Mandatory

  ssh_cidr = "0.0.0.0/0" # Mandatory. Please, don't use this default.

  rds_db_name        = "staging"                   # Mandatory
  rds_username       = "zerfuser"                  # Mandatory
  rds_password       = "${var.rds_password_stage}" # Mandatory
  rds_engine         = "postgres"                  # Optional
  rds_engine_version = "11.5"                      # Optional
  rds_port           = "5432"                      # Optional
  rds_multi_az       = false                       # Optional
  rds_instance_type  = "db.t3.micro"               # Optional

  eb_application         = "zerf-backend"                                                    # Mandatory
  eb_environment         = "stage-back"                                                      # Mandatory
  eb_ec2_key_name        = "zerf-stage"                                                      # Mandatory. Must exist in the account
  eb_environment_type    = "SingleInstance"                                                  # Optional
  eb_instance_type       = "t3.micro"                                                        # Optional
  eb_solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}" # Optional
}

# Frontend public subnets creation for association with backend vpc
resource "aws_subnet" "zerf-backend-stage-front-public" {
  vpc_id     = "${var.vpc_stage_id}"
  cidr_block = "10.0.6.0/24"

  tags = {
    Name = "zerf-backend-stage-front-public"
  }
}

resource "aws_subnet" "zerf-backend-stage-front-public-1" {
  vpc_id     = "${var.vpc_stage_id}"
  cidr_block = "10.0.7.0/24"

  tags = {
    Name = "zerf-backend-stage-front-public-1"
  }
}

# Backend and frontend route table association for subnets
resource "aws_route_table_association" "back-front" {
  subnet_id      = "${aws_subnet.zerf-backend-stage-front-public.id}"
  route_table_id = "${var.vpc_stage_route_table_id}"
}

resource "aws_route_table_association" "back-front-1" {
  subnet_id      = "${aws_subnet.zerf-backend-stage-front-public-1.id}"
  route_table_id = "${var.vpc_stage_route_table_id}"
}

# EB/EC2 for frontend
module "front-stage" {
  source              = "../aws/elasticbeanstalk/environment/"
  vpc_id              = "${var.vpc_stage_id}"
  security_group      = "${var.vpc_sgroup_stage_id}"
  subnets             = ["${aws_subnet.zerf-backend-stage-front-public.id}", "${aws_subnet.zerf-backend-stage-front-public-1.id}"]
  rds_connection_url  = ""
  application         = "zerf-frontend"
  environment         = "stage-front"
  ec2_key_name        = "zerf-stage"                                                                                               # Mandatory. Must exist in the account
  instance_type       = "t3.micro"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.docker_latest.name}"
}

# S3 bucket for backoffice with cloudfront
module "backoffice-stage" {
  source = "../aws/cloudfront_website"

  bucket_name           = "zerf-backoffice-stage" # Mandatory
  bucket_index_document = "index.html"            # Optional
  bucket_error_document = "index.html"            # Optional
  bucket_custom_domain  = ""                      # Optional. For example 'mywebsite.zerf.com.ar'

  # CloudFront variables
  cf_certificate_domain     = ""                  # Optional, e.g. "*.zerf.com.ar"
  cf_enabled                = true                # Optional
  cf_aliases                = []                  # Optional, e.g. ["www.zerf.com.ar", "web.zerf.com.ar"]
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

# S3 bucket for user images with cloudfront
module "images-bucket-stage" {
  source      = "../aws/cloudfront_website"
  bucket_name = "zerf-user-images-stage"    # Mandatory

  # CloudFront variables
  cf_certificate_domain     = ""                  # Optional, e.g. "*.zerf.com.ar"
  cf_enabled                = true                # Optional
  cf_aliases                = []                  # Optional, e.g. ["www.zerf.com.ar", "web.zerf.com.ar"]
  cf_allowed_methods        = ["GET", "HEAD"]     # Optional
  cf_cached_methods         = ["GET", "HEAD"]     # Optional
  cf_forward_query_string   = true                # Optional
  cf_forward_cookies        = "none"              # Optional, one of "all" or "none"
  cf_viewer_protocol_policy = "redirect-to-https" # Optional, one of "allow-all", "https-only" or "redirect-to-https"
  cf_min_ttl                = 0                   # Optional
  cf_default_ttl            = 86400               # Optional
  cf_max_ttl                = 31536000            # Optional
  cf_compress               = true                # Optional
}

# Lambda
locals {
  lambda_name = "bejerman-stage"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${local.lambda_name}"
  filename      = "lambda/lambda.zip"

  handler = "index.handler"
  runtime = "nodejs10.x"
  role    = "${aws_iam_role.lambda_exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-${local.lambda_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = "${aws_iam_role.lambda_exec.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
