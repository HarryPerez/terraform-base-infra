#S3 bucket

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}" #Bucket name
  acl    = "${var.acl}"         #Permissions - Default private. Amazon S3 supports a set of predefined grants, known as canned ACLs.
  policy = "${var.policy}"      #Attaches a policy to an S3 bucket resource. AWS leverages a standard JSON Identity and Access Management (IAM) policy document format across many services to control authorization to resources and API actions. 
}
