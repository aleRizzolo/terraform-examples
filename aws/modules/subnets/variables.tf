variable "vpc_id" {
  type = string
}

variable "app_name" {
  type    = string
  default = "demo"
}

variable "public_cidr" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-south-1a", "eu-south-1b"]
}

variable "lb_subnet_cidr" {
  type = list(string)
}

variable "private_cidrs" {
  type = list(string)
  default = [
    "10.0.32.0/24", # private_ecs_subnet in AZ a
    "10.0.33.0/24", # private_cache_subnet in AZ a
    "10.0.64.0/24", # private_ecs_subnet in AZ b
    "10.0.65.0/24"  # private_cache_subnet in AZ b
  ]
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private_ecs_subnet", "private_cache_subnet"]
}

variable "internetgw_id" {
  type = string
}

variable "eip_allocation_id" {
  type = list(string)
}