#Output file with values that you may need for your app.

output "bucket_id" {
  value = "${aws_s3_bucket.bucket.id}" #Bucket id
}

output "bucket_arn" {
  value = "${aws_s3_bucket.bucket.arn}" #Name of resource on Amazon(ARN)
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}" #Bucket domain name - www.myHaroldBucket.com
}

output "bucket_website_endpoint" {
  value = "${aws_s3_bucket.bucket.website_endpoint}" #When you configure your bucket as a static website, the website is available at the AWS Region-specific website endpoint of the bucket. http://bucket-name.s3-website-Region.amazonaws.com
}

output "bucket_website_domain" {
  value = "${aws_s3_bucket.bucket.website_domain}" #Custom domain
}
