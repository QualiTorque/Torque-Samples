### NOTE: This terraform assumes you already have a bucket deployed, and would like to deploy a static web-app into this bucket.
### The target bucket already has Website Configuration to indext.html and error.html
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_s3_bucket" "target_bucket" {
  bucket = "${var.bucket_name}"
}

data "http" "website_file" {
  url = "https://torque-prod-cfn-assets.s3.amazonaws.com/public-assets/TetrisJS.html"
}


resource "aws_s3_object" "webapp" {
  key          = "index.html"
  bucket       = data.aws_s3_bucket.target_bucket.id
  content      = data.http.website_file.response_body
  acl          = "public-read"
  content_type = "text/html"
}
