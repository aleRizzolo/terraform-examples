variable "app_name" {
  type        = string
  description = "Application name for resource tagging"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where endpoints will be created"
}

variable "region" {
  type        = string
  description = "AWS region for the VPC endpoints"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for interface endpoints"
}

variable "route_table_ids" {
  type        = list(string)
  description = "Route table IDs for S3 gateway endpoint"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for interface endpoints"
}
