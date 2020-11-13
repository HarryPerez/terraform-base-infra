resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}" #Bucket name
  acl    = "public-read"        #Permissions - Default private. Amazon S3 supports a set of predefined grants, known as canned ACLs.

  force_destroy = true #A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable.

  # Attaches a policy to an S3 bucket resource. 
  # AWS leverages a standard JSON Identity and Access Management (IAM) policy document format across many services to control authorization to resources and API actions. 
  # Version - IAM policy document version. Valid values: 2008-10-17, 2012-10-17. Defaults to 2012-10-17. 
  # Sid - An ID for the policy statement.
  # Sid - PublicReadGetObject is an action name. There is a list for it.
  # Statement - A nested configuration block (described below) configuring one statement to be included in the policy document.
  # Effect - Either "Allow" or "Deny", to specify whether this statement allows or denies the given actions. The default is "Allow".
  # Principal - A nested configuration block (described below) specifying a principal (or principal pattern) to which this statement applies.
  # The type of principal. For AWS ARNs this is "AWS". For AWS services (e.g. Lambda), this is "Service". For Federated access the type is "Federated".
  # AWS: * - Defines that every entity with AWS account can access. On the other hand if you put an ID of an account, only that account can access.
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
EOF

  website {
    index_document = "${var.index_document}" #What file show first for access
    error_document = "${var.error_document}" #What file show first for errors
  }

  #Cross-origin resource sharing (CORS) defines a way for client web applications 
  #that are loaded in one domain to interact with resources in a different domain. 
  cors_rule {
    allowed_headers = ["*"]             #With * every type of header is allowed
    allowed_methods = ["GET"]           #POST/GET/ETC that are alloweds
    allowed_origins = ["*"]             #Which origin is alloweds - We can define only 1 domain. Example: http://www.harold.com
    expose_headers  = ["Authorization"] #Specifies expose header in the response.
    max_age_seconds = 3000              #Specifies time in seconds that browser can cache the response for a preflight request.
  }
}
