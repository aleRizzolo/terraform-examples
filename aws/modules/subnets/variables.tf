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
  default     = ["eu-central-1a", "eu-central-1b"]
}

variable "private_cidrs" {
  type = map(string)
}

variable "internetgw_id" {
  type = string
}

variable "eip_allocation_id" {
  type = list(string)
}