variable "region" {
  description = "AWS region"
  type = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = string
  default = "t2.micro"
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type = string
}

variable "record_name" {
  description = "Route 53 record name"
  type = string
}
