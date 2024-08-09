resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = var.record_value
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
}
