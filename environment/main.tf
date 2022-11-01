module "Compute" {
  source     = "./modules/Compute"
  depends_on = [module.Network]

  adam_tags            = var.adam_tags
  ec2_data             = var.ec2_data
  cidr_block           = var.cidr_block
  availability_zone    = var.availability_zone
  aws_internet_gateway = module.Network.aws_internet_gateway
  aws_security_group   = module.Network.aws_security_group
  aws_subnet           = module.Network.aws_subnet
  aws_vpc              = module.Network.aws_vpc

}

module "Network" {
  source = "./modules/Network"

  adam_tags             = var.adam_tags
  cidr_block            = var.cidr_block
  availability_zone     = var.availability_zone
  ingress_one           = var.ingress_one
  ingress_two           = var.ingress_two
  ingress_three         = var.ingress_three
  egress_all            = var.egress_all
  vpc_ip_range          = var.vpc_ip_range
  route_table_ip_range  = var.route_table_ip_range
  server_security_group = var.server_security_group
}