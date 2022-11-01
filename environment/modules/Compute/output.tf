output "instance_id" {
  value = aws_instance.web_server.id
  description = "AWS EC2 instance with Ted Search application on it"
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
  description = "AWS EC2 instance's public IP"
}