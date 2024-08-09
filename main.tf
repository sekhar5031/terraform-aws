module "cloudfront" {
  source          = "./modules/cloudfront"
  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn
}

module "route53" {
  source       = "./modules/route53"
  zone_id      = var.zone_id
  record_name  = var.record_name
  record_type  = "A"
  record_value = module.cloudfront.domain_name
}

module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = var.public_subnet_cidr
  vpc_id        = var.vpc_cidr
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

module "eip" {
  source      = "./modules/eip"
  instance_id = module.ec2.instance_id
}
