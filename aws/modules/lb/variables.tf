variable "app_name" {
  type    = string
  default = "demo"
}

variable "private_lb_subnets_id" {
  type = list(string)
}

variable "sg" {
  type        = list(string)
  description = "Sg for lb"
}

variable "lb_target_group_port" {
  type    = number
  default = 80
}

variable "vpc_id" {
  type    = string
  default = "vpc"
}

variable "lb_listener_port" {
  type    = number
  default = 80
}

variable "health_interval" {
  type = number
}

variable "health_port" {
  type = number
}
