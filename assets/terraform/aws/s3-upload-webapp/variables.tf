variable "region" {
  description = "AWS Region the target bucket is deployed in" 
  type = string
  default = "il-central-1"
}

variable "bucket_name" {
  description = "S3 Bucket to upload to" 
  type = string
}
