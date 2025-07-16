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

variable "desired_count" {
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

variable "lb_target_group_arn" {
  type        = string
  description = "Load balancer arn"
}

variable "private_cidrs_id" {
  type = list(string)
}

variable "security_groups" {
  type        = set(string)
  description = "security group from alb to ecs"
}

variable "ecs_task_cpu" {
  type        = number
  description = "ecs task cpu"
}

variable "ecs_task_memory" {
  type        = number
  description = "ecs task cpu"
}

variable "docdb_user_password" {
  type        = string
  description = "password"
}

variable "docdb_uri" {
  type = string
}

variable "cache_endpoint" {
  type = list(object({
    address = string
    port    = number
  }))
  default = [
    {
      address = "redis://redis"
      port    = "6379"
    }
  ]
}

variable "cache_reader_endpoint" {
  type = list(object({
    address = string
    port    = number
  }))
  default = [
    {
      address = "redis://redis"
      port    = "6380"
    }
  ]
}

variable "test_patient_email" {
  type = string
}

variable "test_medic_email" {
  type = string
}

variable "test_admin_email" {
  type = string
}

variable "test_user_password" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "base_url" {
  type = string
}

variable "shap_url" {
  type = string
}

variable "mail_username" {
  type = string
}

variable "mail_password" {
  type = string
}

variable "mail_from" {
  type = string
}

variable "mail_port" {
  type = string
}

variable "mail_server" {
  type = string
}

variable "mail_from_name" {
  type = string
}

variable "mail_start_tls" {
  type = string
}

variable "mail_ssl_tls" {
  type = string
}

variable "use_credentials" {
  type = string
}

variable "validate_cert" {
  type = string
}

variable "firebase_credentials" {
  type = string
}

variable "google_client_id" {
  type = string
}

variable "facebook_secret" {
  type = string
}

variable "facebook_app_id" {
  type = string
}

variable "rp_id" {
  type = string
}

variable "rp_name" {
  type = string
}

variable "rp_origin" {
  type = string
}

variable "cloudfront_origin" {
  type = string
}

variable "cloudwatch_log_group" {
  type = string
}

variable "container_names" {
  type = list(string)
}

variable "log_group_name" {
  type = string
}

variable "log_arn" {
  type = string
}