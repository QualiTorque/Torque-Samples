# require provideres block
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4.0.0"
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
  id = var.app_subnet_a_id
}

# Wordpress Section
resource "random_pet" "wordpress_pet_name" {
  keepers = {
    # Generate a new pet name each time we switch to a id
    instance_id = aws_instance.sandbox_wordpress_instance.id
  }
}

# Wordpress App
resource "aws_instance" "sandbox_wordpress_instance" {
  ami = local.ubuntu_clean_ami_ids[var.aws_region]
  instance_type = var.instance_type
  key_name = var.keypair_name
  subnet_id = data.aws_subnet.app_subnet.id
  vpc_security_group_ids = [ aws_security_group.Wordpress_Security_Group.id, var.default_security_group_id ]
  user_data = "${replace(file("wordpress.sh"), "#SET_ENVIRONMENT_VARIABLES", "${local.set_params}export DB_HOSTNAME=${var.mysql_private_dns}")}"
  tags = {Name = "Wordpress"}
}

# Wordpress SG
resource "aws_security_group" "Wordpress_Security_Group" {
  name = "Wordpress Security Group"
  description = "wordpress Security Group"
  vpc_id = data.aws_subnet.app_subnet.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ALB_Security_Group.id, var.default_security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB SG
resource "aws_security_group" "ALB_Security_Group" {
  name = "MainALBSG"
  description = "ALB security Group for access to instances"
  vpc_id = data.aws_subnet.app_subnet.vpc_id
  ingress {
    description = "public port access"
    from_port   = 80
    to_port     = 80
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

# Target Group - wordpress - TODO
resource "aws_lb_target_group" "Wordpress_tg" {
  name     = substr("Wordpress-LB-TG-${random_pet.wordpress_pet_name.id}", 0, 32)
  port     = 80
  protocol = "HTTP"
  vpc_id = data.aws_subnet.app_subnet.vpc_id
  health_check {
    path = "/wp-includes/images/blank.gif"
    matcher = "200-299"
    healthy_threshold = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "wordpress_tg_attachment" {
  target_group_arn = aws_lb_target_group.Wordpress_tg.arn
  target_id        = aws_instance.sandbox_wordpress_instance.id
  port             = 80
}

# Target Group - Empty - TODO
resource "aws_lb_target_group" "Empty_tg" {
  name     = "Empty-LB-TG-${random_pet.wordpress_pet_name.id}"
  port     = 80
  protocol = "HTTP"
  vpc_id = data.aws_subnet.app_subnet.vpc_id
}

# ALB - Wordpress
resource "aws_lb" "Wordpress_alb" {
  name               = "wordpressALB-${random_pet.wordpress_pet_name.id}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_Security_Group.id]
  subnets            = [var.app_subnet_a_id, var.app_subnet_b_id]

  tags = {Name = "public-route-table"}
}

resource "aws_lb_listener" "worpdress_listener" {
  load_balancer_arn = aws_lb.Wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Wordpress_tg.arn
  }
}