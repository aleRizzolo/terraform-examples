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

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
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
    "10.0.33.0/24", # private_db_subnet in eu-central-1a
    "10.0.64.0/24", # private_ecs_subnet in eu-central-1b
    "10.0.65.0/24"  # private_db_subnet in eu-central-1b
  ]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private_ecs_subnet", "private_db_subnet"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}

############################## lb ##############################
variable "load_balancer_type" {
  type    = string
  default = "application"
}


variable "alb_target_goup_port" {
  type    = number
  default = 80
}

variable "alb_listner_port" {
  type    = number
  default = 80
}

variable "alb_listner_protocol" {
  type    = string
  default = "HTTP"
}

############################## doc db ##############################
variable "admin_user_name" {
  type      = string
  default   = "user"
  sensitive = true
}

variable "admin_user_password" {
  type      = string
  default   = "user"
  sensitive = true
}

variable "auth_type" {
  type    = string
  default = "PLAIN_TEXT"
}

variable "retention_period" {
  type    = number
  default = 1
}

############################## ecs ##############################
variable "family" {
  type = string
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

############################## ecr ##############################
variable "ecr_name" {
  type    = string
  default = "ecr"
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "encryption_type" {
  type    = string
  default = "AES256"
}

variable "ecr_repository_name" {
  type        = string
  default     = "test"
  description = "Repository defined in task_execution_role"
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

############################## cloudfront ##############################
variable "origin_protocol_policy" {
  type    = string
  default = "http"
}

variable "custom_header_name" {
  type = string
}

variable "custom_header_value" {
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
  description = "List of countries where our app is allowed"
  type        = list(string)
}

variable "price_class" {
  type = string
}

variable "is_cloudfront_staging" {
  type    = bool
  default = true
}