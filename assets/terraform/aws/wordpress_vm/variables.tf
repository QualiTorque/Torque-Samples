variable DB_USER {
    description = "username of the wordpress database" 
    type = string
    default = "root"
}

variable DB_PASS {
    description = "password of the wordpress database" 
    type = string
    default = "12345"
}

variable DB_NAME {
    description = "name of the wordpress database" 
    type = string
    default = "wordpress_demo"
}

variable aws_region {
    description = "AWS Region in which to deploy" 
    type = string
    default = "us-east-1"    
}

variable instance_type {
    description = "AWS instance type for each instance" 
    type = string
    default = "t3a.medium"
}

variable keypair_name {
    description = "Existing AWS Keypair to connect to VMs type for each instance" 
    type = string
    default = "TorqueSandbox"
}

variable "app_subnet_a_id" {
  description = "The application subnet ID to deploy QualiX in"
  type = string  
}

variable "app_subnet_b_id" {
  description = "The application subnet ID to deploy QualiX in"
  type = string  
}

variable "default_security_group_id" {
  description = "The default security group created in Sandbox Infra"
  type = string  
}

variable "mysql_private_dns" {
  type = string
}
  
variable "use_public_ip" {
  type = bool
  default = false
}
