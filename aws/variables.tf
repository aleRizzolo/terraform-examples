variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Default region for aws provider in main.tf file"
}

variable "main_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block of the vpc"
}

variable "public_cidr" {
  type    = string
  default = "10.0.10.0/16"
}

variable "private_cidrs" {
  type = map(string)
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
