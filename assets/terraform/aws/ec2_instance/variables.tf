variable "aws_region" {
    description = "AWS Region in which to deploy" 
    type = string
    default = "us-east-1"    
}

variable "instance_type" {
    description = "AWS instance type for each instance" 
    type = string
    default = "t3a.medium"
}

variable "keypair_name" {
    description = "Existing AWS Keypair to connect to VMs type for each instance" 
    type = string
    default = "TorqueSandbox"
}

variable "app_subnet_a_id" {
  description = "The application subnet ID to deploy QualiX in"
  type = string  
}

variable "default_security_group_id" {
  description = "The default security group created in Environment Infrastructure"
  type = string  
}

variable "inbound_port" {
  type = string
  default = "80"
}

variable "source_ami" {
  type = string
  default = "ami-016587dea5af03adb | Ubuntu with credentials"
}