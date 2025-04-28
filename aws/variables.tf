variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for aws provider in main.tf file"
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

variable "load_balancer_type" {
  type    = string
  default = "application"
}

# doc db
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

variable "subnet_ids" {
  type = list(number)
}

# ecs
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

variable "security_groups" {
  type        = set(string)
  description = "security group from alb to ecs"
}

# ecr
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