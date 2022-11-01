output "aws_internet_gateway" {
  value = aws_internet_gateway.adam-igw
  description = "Internet Gateway to connect with instance(s)"
}

output "aws_security_group" {
  value = aws_security_group.adam-sg
  description = "Security Group used for load balancer and server(s)"
}

output "aws_vpc" {
  value = aws_vpc.adam-vpc
  description = "Virtual Private Cloud hosting all subnets and instances inside"
}

output "aws_subnet" {
  value = aws_subnet.adam-subnet
  description = "Public subnet(s) used for hosting server(s), being open to the outside world"
}