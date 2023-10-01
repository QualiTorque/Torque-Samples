output "wordpress-ip" {
  value = var.use_public_ip ? aws_instance.sandbox_wordpress_instance.public_ip : aws_instance.sandbox_wordpress_instance.private_ip
}

output "wordpress-address" {
  value = aws_lb.Wordpress_alb.dns_name
}
