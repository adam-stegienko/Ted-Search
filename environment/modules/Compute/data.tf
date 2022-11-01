data "aws_vpc" "adam-vpc" {
  id = var.aws_vpc.id
}

data "aws_security_group" "adam-sg" {
  id = var.aws_security_group.id
}

data "aws_internet_gateway" "adam-igw" {
  internet_gateway_id = var.aws_internet_gateway.id
}
  
data "aws_subnet" "adam-subnet" {
  id = var.aws_subnet.id
}
