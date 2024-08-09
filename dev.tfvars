region = "us-west-2"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
ami_id = "ami-0aff18ec83b712f05"
instance_type = "t2.micro"
zone_id = "Z021510216V1WKGFY1GOP"
record_name = "dev.cloudcastnepal.com"
environment = "dev"

# New variables for CloudFront and Route 53
domain_name     = "cloudcastnepal.com"
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/your-certificate-arn"
