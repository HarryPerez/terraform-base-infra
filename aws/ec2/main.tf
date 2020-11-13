resource "aws_instance" "example" {
  ami           = "ami-07bfe0a3ec9dfcffa" # ami for Ubuntu - Amazon Machine Image
  instance_type = "t2.nano"               #Instance type

  # Manually set a VPC
  vpc_security_group_ids = ["sg-0077..."]
  ubnet_id               = "subnet-923a..."
}
