# require provideres block
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>5.0.0"
        }
    }  
}

# Provider block
provider "aws" {
    region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]   # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnet" "app_subnet" {
  id = var.app_subnet_a_id
}

resource "aws_instance" "ubuntu_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.keypair_name
  subnet_id = data.aws_subnet.app_subnet.id
  vpc_security_group_ids = [ aws_security_group.ubuntu_Security_Group.id, var.default_security_group_id ]
}

# Wordpress SG
resource "aws_security_group" "ubuntu_Security_Group" {
  name = "Instance Security Group"
  description = "Instance Security Group"
  vpc_id = data.aws_subnet.app_subnet.vpc_id
  ingress {
    from_port   = var.inbound_port
    to_port     = var.inbound_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}