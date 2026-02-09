variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for aws provider in main.tf file"
}

variable "profile_name" {
  type = string
}

variable "account_id" {
  type        = string
  description = "Account id"
}

variable "app_name" {
  type    = string
  default = "demo"
}

variable "main_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block of the vpc"
}

variable "public_cidr" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_cidrs" {
  type = list(string)
  default = [
    "10.0.32.0/24", # private_ecs_subnet in eu-central-1a
    "10.0.33.0/24", # private_cache_subnet in eu-central-1a
    "10.0.64.0/24", # private_ecs_subnet in eu-central-1b
    "10.0.65.0/24"  # private_cache_subnet in eu-central-1b
  ]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private_ecs_subnet", "private_cache_subnet"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "lb_subnet_cidr" {
  type = list(string)
}

############################## lb ##############################
variable "lb_target_group_port" {
  type    = number
  default = 80
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

############################## ecs ##############################
variable "family" {
  type = string
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

variable "desired_count" {
  type    = number
  default = 1
}

variable "ecs_task_cpu" {
  type        = number
  description = "ecs task cpu"
}

variable "ecs_task_memory" {
  type        = number
  description = "ecs task cpu"
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

variable "cert_name" {
  type = string
}

variable "health_check_grace_period_seconds" {
  type = number
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 10
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 1
}

############################## logs ##############################

variable "logs_retention" {
  type = number
}

variable "cloudwatch_log_group" {
  type = string
}

variable "aws_deploy" {
  type = string
}

variable "log_environment" {
  type = string
}

############################## cache ##############################
variable "minimum_cache_usage_limits" {
  type = number
}

variable "maximum_cache_usage_limits" {
  type = number
}

variable "daily_snapshot_time" {
  type = string
}

variable "description" {
  type = string
}

variable "snapshot_retention_limit" {
  type = number
}

variable "minimum_ecpu_seconds" {
  type    = number
  default = 1000
}

variable "maximum_ecpu_seconds" {
  type    = number
  default = 5000
}

############################## waf ##############################
variable "locations" {
  description = "List of countries where our app is allowed"
  type        = list(string)
}

############################## dynamodb ##############################
variable "billing_mode" {
  type = string
}