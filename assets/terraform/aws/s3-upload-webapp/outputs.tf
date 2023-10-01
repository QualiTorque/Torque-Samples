output "website_link" {
  value = data.aws_s3_bucket.target_bucket.website_endpoint == null ? "http://${data.aws_s3_bucket.target_bucket.bucket_domain_name}/" : "http://${data.aws_s3_bucket.target_bucket.website_endpoint}/"
}
