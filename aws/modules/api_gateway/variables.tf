variable "app_name" {
  type    = string
  default = "demo"
}

variable "nlb_arn" {
  type        = string
  description = "ARN of the Network Load Balancer (VPC Link target)"
}

variable "nlb_dns_name" {
  type        = string
  description = "DNS name of the Network Load Balancer (integration URI)"
}
