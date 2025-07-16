variable "app_name" {
  type    = string
  default = "demo"
}

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

variable "cache_subnet_ids" {
  type = list(string)
}

variable "minimum_ecpu_seconds" {
  type    = number
  default = 1000
}

variable "maximum_ecpu_seconds" {
  type    = number
  default = 5000
}

variable "sg_ids" {
  type = set(string)
}