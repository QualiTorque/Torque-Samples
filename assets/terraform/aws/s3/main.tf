terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  force_destroy = true

  tags = {
    Name        = var.name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_object_ownership" {                                                                   
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  } 
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_public_access_block.public_access_permission,
                aws_s3_bucket_ownership_controls.s3_object_ownership,]
  bucket = aws_s3_bucket.bucket.id
  acl    = var.acl
}


resource "aws_s3_bucket_public_access_block" "public_access_permission" {
  bucket = aws_s3_bucket.bucket.id
  
  block_public_acls       = startswith(var.acl, "public") ? false : true
  block_public_policy     = startswith(var.acl, "public") ? false : true
  ignore_public_acls      = startswith(var.acl, "public") ? false : true
  restrict_public_buckets = startswith(var.acl, "public") ? false : true
}