# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-central-1"
}

variable "lambda_bucket_name" {
  description = "Existing AWS Bucket to store serverless code artifacts."

  type    = string
  default = "torque-lambda-storage"
}

variable "lambda_iam_role" {
  description = "Name of IAM role to execute serverless function."

  type    = string
  default = "torque-lambda-exec"
}
