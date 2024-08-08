output "instance_id" {
  value = module.ec2.instance_id
}

output "eip" {
  value = module.eip.eip
}

output "route53_record" {
  value = module.route53.record
}
