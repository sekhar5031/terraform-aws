variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type = string
}

variable "record_name" {
  description = "Route 53 record name"
  type = string
}

variable "record_type" {
  description = "Route 53 record type"
  type = string
}

variable "record_value" {
  description = "Route 53 record value"
  type = string
}
