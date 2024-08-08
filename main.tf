module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_id
}

module "eip" {
  source = "./modules/eip"
  instance_id = module.ec2.instance_id
}

module "route53" {
  source = "./modules/route53"
  zone_id = var.zone_id
  record_name = var.record_name
  record_type = "A"
  record_value = module.eip.eip
}
