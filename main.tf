module "cloudfront" {
  source          = "./modules/cloudfront"
  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn
}

module "route53" {
  source      = "./modules/route53"
  domain_name = var.domain_name
  zone_id     = var.zone_id
}
