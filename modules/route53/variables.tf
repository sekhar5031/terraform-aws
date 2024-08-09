variable "zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "record_name" {
  description = "The DNS record name"
  type        = string
}

variable "record_type" {
  description = "The DNS record type"
  type        = string
}

variable "record_value" {
  description = "The DNS record value"
  type        = string
}
