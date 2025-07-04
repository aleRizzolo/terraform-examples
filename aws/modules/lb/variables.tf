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

variable "sg" {
  type        = list(string)
  description = "Sg for alb"
}

variable "alb_target_goup_port" {
  type    = number
  default = 80
}

variable "vpc_id" {
  type    = string
  default = "vpc"
}

variable "alb_listner_port" {
  type    = number
  default = 80
}

variable "alb_listner_protocol" {
  type    = string
  default = "HTTP"
}