variable "app_name" {
  type    = string
  default = "demo"
}

variable "family" {
  type    = string
  default = "demo"
}

variable "container_name" {
  type    = string
  default = "container"
}

variable "ecs_image" {
  type    = string
  default = "nginx:latest"
}

variable "ecs_container_cpu" {
  type    = number
  default = 10
}

variable "ecs_container_memory" {
  type    = number
  default = 512
}

variable "container_port" {
  type    = number
  default = 80
}

variable "host_port" {
  type    = number
  default = 80
}

variable "desidered_count" {
  type    = number
  default = 1
}