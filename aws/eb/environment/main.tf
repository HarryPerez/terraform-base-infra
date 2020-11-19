variable "environment" {}
variable "vpc_id" {}
variable "ec2_key_name" {}
variable "application" {}
variable "security_group" {}
variable "rds_connection_url" {}

#Set of subnets to assign to this environment
variable "subnets" {
  type = "list"
}

#Supported platforms - Docker/Go/Multicontainer Docker/Java/Tomcat/Node.js/PHP/Ruby/.NET Core
variable "solution_stack_name" {
  default = "64bit Amazon Linux 2017.09 v2.8.4 running Docker 17.09.1-ce"
}

#Single instance - Load balanced, scalable
variable "environment_type" {
  default = "SingleInstance"
}

#Like all instance types - defines size
variable "instance_type" {
  default = "t3.small"
}

#Show logs on CloudWatch Logs if you want
variable "stream_logs" {
  default = "false"
}

# If multiple env is setted
# variable "load_balancer_type" {
#   default = "classic"
# }

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "${var.environment}"         #A unique name for this Environment. This name is used in the application URL
  application         = "${var.application}"         #Name of the application that contains the version to be deployed - zerf-backend
  solution_stack_name = "${var.solution_stack_name}" #A solution stack to base your environment off of. Example stacks can be found in the Amazon API documentation - 64bit Amazon Linux 2 v3.2.1 running Docker

  # Option settings to configure the new Environment. These override specific values that are set as defaults.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.subnets)}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "${var.environment_type}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.subnets)}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }

  #Specifies whether to launch instances with public IP addresses in your Amazon VPC. 
  #Instances with public IP addresses do not require a NAT device to communicate with the Internet. 
  #You must set the value to true if you want to include your load balancer and instances in a single public subnet.
  #This option has no effect on a single-instance environment, which always has a single Amazon EC2 instance with an Elastic IP address. The option is relevant to load-balanced, scalable environments.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  #Configure your environment's Amazon Elastic Compute Cloud (Amazon EC2) instances.
  #Your environment's instances are created using either an Amazon EC2 launch template or an Auto Scaling group launch configuration resource. 
  #These options work with both of these resource types
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${var.security_group}"
  }

  #A key pair enables you to securely log into your EC2 instance.
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ec2_key_name}"
  }

  #Configure enhanced health reporting for your environment.
  #Health reporting system (basic or enhanced). 
  #Enhanced health reporting requires a service role and a version 2 or newer platform version.
  #Enhanced health reporting is a feature that you can enable on your environment to allow AWS Elastic Beanstalk to gather additional
  # information about resources in your environment. 
  #Elastic Beanstalk analyzes the information gathered to provide a better picture of overall 
  # environment health and aid in the identific
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  #An instance profile enables AWS Identity and Access Management 
  #(IAM) users and AWS services to access temporary security credentials to make AWS API calls. 
  #Specify the instance profile's name or its ARN.
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.ec2-role.name}"
  }

  #The maximum instance count to apply when the action runs.
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.environment_type == "SingleInstance" ? "1" : "2"}"
  }

  #RDS Url
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = "${var.rds_connection_url}"
  }

  #Use or not ouse cloudwatch
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "${var.stream_logs}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "false"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "30"
  }
}

#Fully qualified DNS name for this Environment.
output "cname" {
  value = "${aws_elastic_beanstalk_environment.env.cname}"
}
