terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region = var.region
}


locals {
  sizeMap = {
    "small"  = "db.t3.small"
    "medium" = "db.t3.medium"
    "large"  = "db.t3.large"
  }
  instance_class = lookup(local.sizeMap, lower(var.size), "db.t4g.medium")
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_default_vpc" "default" {
  tags = {Name = "Default VPC"}
}

data "aws_subnet_ids" "apps_subnets" {
  vpc_id = "${aws_default_vpc.default.id}"
  filter {
    name = "tag:Name"
    values = ["app-rds*"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-${var.env_id}-subnet-group"
  subnet_ids = data.aws_subnet_ids.apps_subnets.ids

  tags = {
    Name = "rds-${var.env_id}-subnet-group"
  }
}

resource "aws_security_group" "rds_security_group" {
  name        = "rds-${var.env_id}_sg"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "rds_instance" {
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = local.instance_class
  identifier                = "rds-${var.env_id}"
  name                      = "${var.db_name}"
  username                  = "${var.username}"
  password                  = "${random_password.password.result}"
  publicly_accessible       = true
  db_subnet_group_name      = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids    = [aws_security_group.rds_security_group.id]
  skip_final_snapshot       = true
  final_snapshot_identifier = "Ignore"
}
