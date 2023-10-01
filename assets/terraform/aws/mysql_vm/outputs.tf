output "mysql-ip" {
  value = var.use_public_ip ? aws_instance.sandbox_mysql_instance.public_ip : aws_instance.sandbox_mysql_instance.private_ip
}

output "mysql-private-dns" {
  value = aws_instance.sandbox_mysql_instance.private_dns
}