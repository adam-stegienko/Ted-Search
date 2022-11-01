resource "aws_vpc" "adam-vpc" {
  cidr_block = var.vpc_ip_range
  enable_dns_hostnames = true

  lifecycle {
    create_before_destroy = true
  }

  tags = var.adam_tags
}

resource "aws_subnet" "adam-subnet" {
  vpc_id            = aws_vpc.adam-vpc.id
  cidr_block        = var.cidr_block[0]
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true

  lifecycle {
    create_before_destroy = true
  }

  tags = var.adam_tags
}

resource "aws_internet_gateway" "adam-igw" {
  vpc_id = aws_vpc.adam-vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.adam_tags
}

resource "aws_route_table" "adam-rtb" {
  vpc_id = aws_vpc.adam-vpc.id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.adam_tags

  route {
    cidr_block = var.route_table_ip_range
    gateway_id = aws_internet_gateway.adam-igw.id
  }
}

resource "aws_route_table_association" "adam_association" {
  subnet_id      = aws_subnet.adam-subnet.id
  route_table_id = aws_route_table.adam-rtb.id

  lifecycle {
    create_before_destroy = true
  }
}