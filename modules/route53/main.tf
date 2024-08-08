resource "aws_route53_record" {
  zone_id = var.zone_id
  name = var.record_name
  type = var.record_type
  ttl = 300
  records = [var.record_value]
}

output "record" {
  value = aws_route53_record.main.fqdn
}
