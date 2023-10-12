output "instance-ip" {
  value = aws_instance.ubuntu_instance.public_ip 
}

output "instance-port-link" {
  value = "http://${aws_instance.ubuntu_instance.public_ip}:${var.inbound_port}"
}
