ec2_data = {
  name          = "web_server"
  ami           = "ami-0caef02b518350c8b"
  instance_type = "t2.micro"
}
cidr_block        = ["10.10.0.192/28"]
availability_zone = ["eu-central-1b"]
adam_tags = {
  bootcamp   = "poland1"
  created_by = "Adam Stegienko"
  Name       = "DEV_Adam_Stegienko_TED"
}
ingress_one = {
  description = "Inbound connection"
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = "0.0.0.0/0"
}
ingress_two = {
  description = "Inbound connection"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"
  cidr_blocks = "0.0.0.0/0"
}
ingress_three = {
  description = "Inbound connection"
  from_port   = 11211
  to_port     = 11211
  protocol    = "TCP"
  cidr_blocks = "0.0.0.0/0"
}
egress_all = {
  description      = "Outbound connection"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = "0.0.0.0/0"
  ipv6_cidr_blocks = "::/0"
}
vpc_ip_range         = "10.10.0.0/24"
route_table_ip_range = "0.0.0.0/0"
server_security_group = {
  name        = "adam-server-sg"
  description = "Security Group for Ted Search"
}