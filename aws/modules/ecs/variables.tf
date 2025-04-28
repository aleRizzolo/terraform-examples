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

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for aws provider in main.tf file"
}

variable "account_id" {
  type        = string
  description = "Account id"
}

variable "ecr_repository_name" {
  type        = string
  default     = "test"
  description = "Repository defined in task_execution_role"
}

variable "lb_arn" {
  type        = string
  description = "Load balancer arn"
}