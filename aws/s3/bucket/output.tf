#Output file with values that you may need for your app.

output "bucket_id" {
  value = "${aws_s3_bucket.bucket.id}" # Bucket id
}

output "bucket_arn" {
  value = "${aws_s3_bucket.bucket.arn}" #Name of resource on Amazon(ARN)
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}" #Bucket domain name - www.myHaroldBucket.com
}
