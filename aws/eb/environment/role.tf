# EC2 instances
# New role
resource "aws_iam_role" "ec2-role" {
  name = "${var.application}-${var.environment}-ec2-role"

  #The policy that grants an entity permission to assume the role.
  #A policy that grants a user permission to assume a role must include a statement with the Allow effect.
  #This allows a user to assume role in ec2 service
  #Returns a set of temporary security credentials that you can use to access AWS resources that you might not normally have access to
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Defines a profile
resource "aws_iam_instance_profile" "ec2-role" {
  name = "${var.application}-${var.environment}-eb-ec2-role"
  role = "${aws_iam_role.ec2-role.name}"
}

#Attaches a Managed IAM Policy to an IAM role
#Example: AWSElasticBeanstalkFullAccess
resource "aws_iam_role_policy_attachment" "web" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

#Attaches a Managed IAM Policy to an IAM role
#Example: AWSElasticBeanstalkFullAccess
resource "aws_iam_role_policy_attachment" "multicontainer" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

#Worker is for async - "threads"
#To avoid running long-running tasks locally, you can use the AWS SDK for your programming language to send them to an Amazon Simple Queue Service (Amazon SQS) queue, 
#and run the process that performs them on a separate set of instances.
#Elastic Beanstalk worker environments simplify this process by managing the Amazon SQS queue 
#and running a daemon process on each instance that reads from the queue for you.
resource "aws_iam_role_policy_attachment" "worker" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

#Description of the environment
resource "aws_iam_role_policy_attachment" "describe_environment" {
  role       = "${aws_iam_role.ec2-role.name}"
  policy_arn = "${aws_iam_policy.describe_environment.arn}"
}

#Returns descriptions for existing environments.
resource "aws_iam_policy" "describe_environment" {
  name        = "describe-environment-${var.application}-${var.environment}"
  description = "Allows EC2 instance to describe the Elastic Beanstalk environment"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "elasticbeanstalk:DescribeEnvironments",
            "Resource": "${aws_elastic_beanstalk_environment.env.arn}"
        }
    ]
}
EOF
}

# EB Service
resource "aws_iam_role" "eb-service-role" {
  name = "${var.application}-${var.environment}-eb-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Returns health of environment
resource "aws_iam_role_policy_attachment" "eb_health" {
  role       = "${aws_iam_role.eb-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

output "eb-ec2-role" {
  value = "${aws_iam_role.ec2-role.name}"
}
