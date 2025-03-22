variable "app_name" {
  type    = string
  default = "demo"
}

variable "public_subnets_id" {
  type = list(string)
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}