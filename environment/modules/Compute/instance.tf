resource "aws_instance" "web_server" {
  depends_on = [data.aws_internet_gateway.adam-igw]

  ami                    = var.ec2_data["ami"]
  instance_type          = var.ec2_data["instance_type"]
  subnet_id              = data.aws_subnet.adam-subnet.id
  vpc_security_group_ids = [data.aws_security_group.adam-sg.id]
  key_name = "adam-lab"
  
  tags                   = var.adam_tags
  volume_tags            = var.adam_tags

  lifecycle {
    create_before_destroy = true
  }
}

