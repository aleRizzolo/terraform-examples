variable "app_name" {
  type    = string
  default = "demo"
}

variable "locations" {
  description = "List of allowed country codes for geo-blocking"
  type        = list(string)
}

variable "api_gateway_stage_arn" {
  type        = string
  description = "ARN of the API Gateway stage to associate the WAF with"
}