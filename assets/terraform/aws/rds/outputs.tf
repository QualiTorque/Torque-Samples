output "hostname" {
  value = "${aws_db_instance.rds_instance.endpoint}"
}
output "connection_string" {
  sensitive = true
  value = "Server=${aws_db_instance.rds_instance.address};Port=${aws_db_instance.rds_instance.port};Database=${var.db_name};Uid=${var.username};Pwd=${random_password.password.result};"
}