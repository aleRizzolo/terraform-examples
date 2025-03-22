variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for aws provider in main.tf file"
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
