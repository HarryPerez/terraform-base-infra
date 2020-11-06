#Elastic Beanstalk is the fastest and simplest way to deploy your application on AWS. 
#You simply use the AWS Management Console, a Git repository, or an integrated development environment (IDE) such as Eclipse or Visual Studio to upload your application, and Elastic Beanstalk automatically handles the deployment details of capacity provisioning, load balancing, auto-scaling, and application health monitoring. 
#Within minutes, your application will be ready to use without any infrastructure or resource configuration work on your part.
variable "application" {}

#Provides an Elastic Beanstalk Application Resource. 
#Elastic Beanstalk allows you to deploy and manage applications in the AWS cloud without worrying about the infrastructure that runs those applications.
#This resource creates an application that has one configuration template named default, and no application versions
resource "aws_elastic_beanstalk_application" "app" {
  name = "${var.application}"
}
