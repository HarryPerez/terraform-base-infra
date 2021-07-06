output "application_name" {
  value = "${aws_elastic_beanstalk_application.app.name}" #The name of the application, must be unique within your account. Example: "wells-sensor-monitoring-node”
}
