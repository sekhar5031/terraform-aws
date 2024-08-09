variable "domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}
