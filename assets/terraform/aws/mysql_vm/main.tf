# require provideres block
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0"
        }
    }  
}

# Provider block
provider "aws" {
    region = var.aws_region
}

# MySQL Section
locals {
  set_params = "export DB_PASS=${var.DB_PASS}\nexport DB_USER=${var.DB_USER}\nexport DB_NAME=${var.DB_NAME}\n"
  ubuntu_clean_ami_ids = {
    "il-central-1"  = "ami-0d61ab1d0c53cbc89"
    "eu-west-1"     = "ami-016587dea5af03adb"
  }
}

data "aws_subnet" "app_subnet" {
  id = var.app_subnet_id
}

# MySQL App
resource "aws_instance" "sandbox_mysql_instance" {
  ami = local.ubuntu_clean_ami_ids[var.aws_region]
  instance_type = var.instance_type
  key_name = var.keypair_name
  subnet_id = var.app_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.MySQL_Security_Group.id, var.default_security_group_id ]
  user_data = "${replace(file("mysql.sh"), "#SET_ENVIRONMENT_VARIABLES", local.set_params)}"
  tags = {Name = "MySQL"}
}

# MySQL SG
resource "aws_security_group" "MySQL_Security_Group" {
  name = "MySQL Security Group"
  description = "mysql Security Group"
  vpc_id = data.aws_subnet.app_subnet.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.default_security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}