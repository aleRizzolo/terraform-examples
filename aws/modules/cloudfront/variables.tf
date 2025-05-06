variable "app_name" {
  type    = string
  default = "demo"
}

variable "origin_protocol_policy" {
  type    = string
  default = "http"
}

variable "alb_dns_name" {
  type = string
}

variable "custom_header_name" {
  type = string
}

variable "custom_header_value" {
  type = string
}

variable "origin_id" {
  type = string
}

variable "cache_policy_name" {
  type    = string
  default = "cache-policy"
}

variable "min_ttl" {
  type = number
}

variable "max_ttl" {
  type = number
}

variable "allowed_methods" {
  type = list(string)
}

variable "viewer_protocol_policy" {
  type = string
}

variable "locations" {
  type = list(string)
}

variable "price_class" {
  type = string
}

variable "is_cloudfront_staging" {
  type    = bool
  default = true
}