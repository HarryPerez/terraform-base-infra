#Define vars which are user inside main.tf

variable "bucket_name" {}

variable "policy" {
  default = ""
}

variable "acl" {
  default = "public-read"
}
